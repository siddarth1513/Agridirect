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

    def validate_latitude(self, value):
        if value is not None:
            if not (-90.0 <= float(value) <= 90.0):
                raise serializers.ValidationError("Latitude must be between -90 and 90 degrees.")
        return value

    def validate_longitude(self, value):
        if value is not None:
            if not (-180.0 <= float(value) <= 180.0):
                raise serializers.ValidationError("Longitude must be between -180 and 180 degrees.")
        return value

class BuyerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = BuyerProfile
        fields = ('id', 'user', 'delivery_address', 'latitude', 'longitude', 'rating')
        read_only_fields = ('id', 'user', 'rating')

    def validate_latitude(self, value):
        if value is not None:
            if not (-90.0 <= float(value) <= 90.0):
                raise serializers.ValidationError("Latitude must be between -90 and 90 degrees.")
        return value

    def validate_longitude(self, value):
        if value is not None:
            if not (-180.0 <= float(value) <= 180.0):
                raise serializers.ValidationError("Longitude must be between -180 and 180 degrees.")
        return value
