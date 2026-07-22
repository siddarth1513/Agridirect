from django.db import models
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver

class FarmerProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='farmer_profile')
    farm_name = models.CharField(max_length=255, blank=True)
    farm_address = models.TextField(blank=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=5.0)

    def __str__(self):
        return self.farm_name or f"Farm profile of {self.user.email}"

class FarmImage(models.Model):
    profile = models.ForeignKey(FarmerProfile, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='farm_images/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Image for {self.profile.farm_name or self.profile.user.email}"

class BuyerProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='buyer_profile')
    delivery_address = models.TextField(blank=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=5.0)

    def __str__(self):
        return f"Buyer profile of {self.user.email}"

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        from accounts.models import User
        if instance.role == User.Roles.FARMER:
            FarmerProfile.objects.create(user=instance)
        elif instance.role == User.Roles.BUYER:
            BuyerProfile.objects.create(user=instance)
