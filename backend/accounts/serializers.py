from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'phone_number', 'role')
        extra_kwargs = {'email': {'required': True}}

    def validate_password(self, value):
        from django.contrib.auth.password_validation import validate_password
        from django.core.exceptions import ValidationError
        try:
            validate_password(value)
        except ValidationError as e:
            raise serializers.ValidationError(list(e.messages))
        return value

    def validate_phone_number(self, value):
        if value:
            import re
            cleaned = re.sub(r'[\s\-\(\)]', '', value)
            if cleaned.startswith('+'):
                digits_only = cleaned[1:]
            else:
                digits_only = cleaned
            if not digits_only.isdigit() or not (5 <= len(digits_only) <= 15):
                raise serializers.ValidationError("Phone number must contain between 5 and 15 digits.")
        return value

    def create(self, validated_data):
        user = User.objects.create_user(
            email=validated_data['email'],
            password=validated_data['password'],
            phone_number=validated_data.get('phone_number', ''),
            role=validated_data.get('role', User.Roles.BUYER)
        )
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'phone_number', 'role')
        read_only_fields = ('id', 'email', 'role')


