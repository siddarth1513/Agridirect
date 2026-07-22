from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from .models import FarmerProfile, BuyerProfile, FarmImage
from .serializers import FarmerProfileSerializer, BuyerProfileSerializer, FarmImageSerializer
from accounts.models import User

class UserProfileView(generics.RetrieveUpdateAPIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get_serializer_class(self):
        if self.request.user.role == User.Roles.FARMER:
            return FarmerProfileSerializer
        return BuyerProfileSerializer

    def get_object(self):
        if self.request.user.role == User.Roles.FARMER:
            profile, _ = FarmerProfile.objects.get_or_create(user=self.request.user)
            return profile
        else:
            profile, _ = BuyerProfile.objects.get_or_create(user=self.request.user)
            return profile

class FarmImageUploadView(generics.CreateAPIView):
    permission_classes = (permissions.IsAuthenticated,)
    serializer_class = FarmImageSerializer
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        if request.user.role != User.Roles.FARMER:
            return Response({"error": "Only farmers can upload farm images"}, status=status.HTTP_403_FORBIDDEN)
        
        # Ensure profile exists
        profile, _ = FarmerProfile.objects.get_or_create(user=request.user)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(profile=profile)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
