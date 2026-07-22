from django.urls import path
from .views import UserProfileView, FarmImageUploadView

urlpatterns = [
    path('me/', UserProfileView.as_view(), name='user_profile'),
    path('farm-images/', FarmImageUploadView.as_view(), name='farm_image_upload'),
]
