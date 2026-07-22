from rest_framework import serializers
from .models import FarmerProfile, FarmImage, BuyerProfile
from accounts.serializers import UserSerializer

class FarmImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmImage
        fields = ('id', 'image', 'uploaded_at')

class FarmerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    images = FarmImageSerializer(many=True, read_only=True)

    class Meta:
        model = FarmerProfile
        fields = ('id', 'user', 'farm_name', 'farm_address', 'latitude', 'longitude', 'rating', 'images')
        read_only_fields = ('id', 'user', 'rating', 'images')

class BuyerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = BuyerProfile
        fields = ('id', 'user', 'delivery_address', 'latitude', 'longitude', 'rating')
        read_only_fields = ('id', 'user', 'rating')
