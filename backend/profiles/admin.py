from django.contrib import admin
from .models import FarmerProfile, FarmImage, BuyerProfile

class FarmImageInline(admin.TabularInline):
    model = FarmImage
    extra = 1

@admin.register(FarmerProfile)
class FarmerProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'farm_name', 'rating', 'latitude', 'longitude')
    search_fields = ('user__email', 'farm_name', 'farm_address')
    list_filter = ('rating',)
    inlines = [FarmImageInline]

@admin.register(BuyerProfile)
class BuyerProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'rating', 'latitude', 'longitude')
    search_fields = ('user__email', 'delivery_address')
    list_filter = ('rating',)

@admin.register(FarmImage)
class FarmImageAdmin(admin.ModelAdmin):
    list_display = ('profile', 'image', 'uploaded_at')
    search_fields = ('profile__farm_name', 'profile__user__email')
