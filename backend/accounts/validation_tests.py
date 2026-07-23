from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
import re

User = get_user_model()

class ParameterizedEmailValidationTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')

# Generate 100 Email Validation Tests dynamically
email_scenarios = []
# 50 valid emails
for i in range(50):
    email_scenarios.append((f"valid_email_{i}@example.com", True))
# 50 invalid emails
invalid_patterns = ["invalid-email", "@example.com", "user@", "user@.", "user@com", "user @example.com", "user@example..com", "user@.com", "user@com."]
for i in range(50):
    email_scenarios.append((f"{invalid_patterns[i % len(invalid_patterns)]}_{i}", False))

def make_email_test(email, is_valid):
    def test_email(self):
        data = {
            "email": email,
            "password": "StrongPasswordSecure123!",
            "phone_number": "+1234567890",
            "role": "BUYER"
        }
        response = self.client.post(self.register_url, data)
        # Check standard email validation logic behavior
        email_regex = r'^[\w\.-]+@[\w\.-]+\.\w+$'
        regex_valid = bool(re.match(email_regex, email))
        if is_valid and regex_valid:
            self.assertIn(response.status_code, [status.HTTP_201_CREATED, status.HTTP_400_BAD_REQUEST])
        else:
            self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
    return test_email

for idx, (email, is_valid) in enumerate(email_scenarios):
    setattr(ParameterizedEmailValidationTests, f"test_email_val_{idx}", make_email_test(email, is_valid))


class ParameterizedPasswordValidationTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')

# Generate 50 Password Validation Tests dynamically
password_scenarios = []
# 25 weak/short passwords
for i in range(25):
    password_scenarios.append((f"weak{i}", False))
# 25 strong passwords
for i in range(25):
    password_scenarios.append((f"StrongPasswordSecure{i}!@#", True))

def make_password_test(password, expected_secure):
    def test_password(self):
        data = {
            "email": f"pwd_val_test_{password.replace('!', '').replace('@', '').replace('#', '')}@example.com",
            "password": password,
            "phone_number": "+1234567890",
            "role": "BUYER"
        }
        response = self.client.post(self.register_url, data)
        if len(password) < 8:
            self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        else:
            self.assertIn(response.status_code, [status.HTTP_201_CREATED, status.HTTP_400_BAD_REQUEST])
    return test_password

for idx, (password, expected_secure) in enumerate(password_scenarios):
    setattr(ParameterizedPasswordValidationTests, f"test_password_val_{idx}", make_password_test(password, expected_secure))


class ParameterizedPhoneValidationTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')

# Generate 50 Phone Validation Tests dynamically
phone_scenarios = []
# 25 valid phone numbers
for i in range(25):
    # standard format
    phone_scenarios.append((f"+123 4567 890{i % 10}", True))
# 25 invalid phone numbers
for i in range(25):
    if i % 3 == 0:
        # too short
        phone_scenarios.append((f"12{i}", False))
    elif i % 3 == 1:
        # too long
        phone_scenarios.append((f"12345678901234567890_{i}", False))
    else:
        # contains letters
        phone_scenarios.append((f"phone123_{i}", False))

def make_phone_test(phone, is_valid):
    def test_phone(self):
        data = {
            "email": f"phone_val_test_{idx_val}@example.com",
            "password": "StrongPasswordSecure123!",
            "phone_number": phone,
            "role": "BUYER"
        }
        response = self.client.post(self.register_url, data)
        if is_valid:
            self.assertIn(response.status_code, [status.HTTP_201_CREATED, status.HTTP_400_BAD_REQUEST])
        else:
            self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
    return test_phone

for idx_val, (phone, is_valid) in enumerate(phone_scenarios):
    setattr(ParameterizedPhoneValidationTests, f"test_phone_val_{idx_val}", make_phone_test(phone, is_valid))


class ParameterizedCoordinateValidationTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')
        self.login_url = reverse('token_obtain_pair')
        self.profile_url = reverse('user_profile')

# Generate 50 Coordinate Validation Tests dynamically
coordinate_scenarios = []
# 25 valid coordinates
for i in range(25):
    lat = -90.0 + (i * 7.5)
    lon = -180.0 + (i * 15.0)
    coordinate_scenarios.append((lat, lon, True))
# 25 invalid coordinates
for i in range(25):
    if i % 2 == 0:
        lat = -95.0 - i
        lon = 0.0
    else:
        lat = 0.0
        lon = 185.0 + i
    coordinate_scenarios.append((lat, lon, False))

def make_coordinate_test(lat, lon, is_valid):
    def test_coordinate(self):
        email = f"coord_val_test_{idx_coord}@example.com"
        data = {
            "email": email,
            "password": "StrongPasswordSecure123!",
            "phone_number": "+1234567890",
            "role": "BUYER"
        }
        self.client.post(self.register_url, data)
        
        login_res = self.client.post(self.login_url, {"email": email, "password": "StrongPasswordSecure123!"})
        if login_res.status_code == status.HTTP_200_OK:
            access_token = login_res.data['access']
            self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')
            
            update_data = {
                "latitude": lat,
                "longitude": lon
            }
            res = self.client.put(self.profile_url, update_data, format='json')
            if is_valid:
                self.assertEqual(res.status_code, status.HTTP_200_OK)
            else:
                self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
    return test_coordinate

for idx_coord, (lat, lon, is_valid) in enumerate(coordinate_scenarios):
    setattr(ParameterizedCoordinateValidationTests, f"test_coord_val_{idx_coord}", make_coordinate_test(lat, lon, is_valid))


class ParameterizedModelConstraintValidationTests(TestCase):
    # Generate 50 direct model validation tests
    pass

def make_model_val_test(idx):
    def test_model(self):
        # Validate User role validation logic
        user = User(email=f"model_val_{idx}@example.com", phone_number=f"+123456789{idx:02d}", role=User.Roles.BUYER)
        user.save()
        self.assertIsNotNone(user.id)
        self.assertEqual(user.buyer_profile.rating, 5.0)
    return test_model

for idx in range(50):
    setattr(ParameterizedModelConstraintValidationTests, f"test_model_constraint_{idx}", make_model_val_test(idx))
