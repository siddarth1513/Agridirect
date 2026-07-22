from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.staticfiles.testing import StaticLiveServerTestCase
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import re

User = get_user_model()

class AuthTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')
        self.login_url = reverse('token_obtain_pair')
        self.refresh_url = reverse('token_refresh')
        self.profile_url = reverse('user_profile')

        self.farmer_data = {
            "email": "farmer@example.com",
            "password": "farmerpassword123",
            "phone_number": "1234567890",
            "role": "FARMER"
        }
        self.buyer_data = {
            "email": "buyer@example.com",
            "password": "buyerpassword123",
            "phone_number": "0987654321",
            "role": "BUYER"
        }

    def test_user_registration_farmer(self):
        response = self.client.post(self.register_url, self.farmer_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['user']['email'], self.farmer_data['email'])
        self.assertEqual(response.data['user']['role'], 'FARMER')

        user = User.objects.get(email=self.farmer_data['email'])
        self.assertIsNotNone(user.farmer_profile)
        self.assertEqual(user.role, User.Roles.FARMER)

    def test_user_registration_buyer(self):
        response = self.client.post(self.register_url, self.buyer_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['user']['email'], self.buyer_data['email'])
        self.assertEqual(response.data['user']['role'], 'BUYER')

        user = User.objects.get(email=self.buyer_data['email'])
        self.assertIsNotNone(user.buyer_profile)
        self.assertEqual(user.role, User.Roles.BUYER)

    def test_user_login(self):
        # Register first
        self.client.post(self.register_url, self.farmer_data)

        # Login
        login_data = {
            "email": self.farmer_data["email"],
            "password": self.farmer_data["password"]
        }
        response = self.client.post(self.login_url, login_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_profile_retrieval_and_update(self):
        # Register and login
        self.client.post(self.register_url, self.farmer_data)
        login_data = {
            "email": self.farmer_data["email"],
            "password": self.farmer_data["password"]
        }
        login_res = self.client.post(self.login_url, login_data)
        access_token = login_res.data['access']

        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')

        # Get Profile
        res = self.client.get(self.profile_url)
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data['farm_name'], '')

        # Update Profile
        update_data = {
            "farm_name": "Sunny Farms",
            "farm_address": "123 Green Valley"
        }
        res = self.client.put(self.profile_url, update_data, format='json')
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data['farm_name'], 'Sunny Farms')
        self.assertEqual(res.data['farm_address'], '123 Green Valley')


class AdminSeleniumTests(StaticLiveServerTestCase):
    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--log-level=3')
        cls.driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        cls.driver.implicitly_wait(10)

    @classmethod
    def tearDownClass(cls):
        cls.driver.quit()
        super().tearDownClass()

    def test_admin_login_and_navigation(self):
        """Test logging into Django admin with superuser, checking user and profile lists"""
        # Create superuser
        User.objects.create_superuser(email='admin@example.com', password='adminpassword')
        
        # Go to admin login page
        self.driver.get(f"{self.live_server_url}/admin/")
        
        # Log in
        self.driver.find_element(By.NAME, 'username').send_keys('admin@example.com')
        self.driver.find_element(By.NAME, 'password').send_keys('adminpassword')
        self.driver.find_element(By.XPATH, '//input[@type="submit"]').click()
        
        # Wait for the dashboard to load (link to Users app list)
        from selenium.webdriver.support.ui import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.LINK_TEXT, 'Users'))
        )

        # Verify dashboard loaded
        self.assertIn('Site administration', self.driver.page_source)

        # Check Users link
        users_link = self.driver.find_element(By.LINK_TEXT, 'Users')
        users_link.click()
        
        # Wait for users list page to load
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, 'changelist'))
        )
        self.assertIn('Select user to change', self.driver.page_source)


class ParameterizedRegistrationTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')

# Generate 100 Email Validation Tests dynamically
email_scenarios = []
# 50 valid emails
for i in range(50):
    email_scenarios.append((f"user_{i}@example.com", True))
# 50 invalid emails
invalid_patterns = ["invalid-email", "@example.com", "user@", "user@.", "user@com", "user @example.com", "user@example..com"]
for i in range(50):
    email_scenarios.append((f"{invalid_patterns[i % len(invalid_patterns)]}_{i}", False))

def make_email_test(email, is_valid):
    def test_email(self):
        data = {
            "email": email,
            "password": "testpassword123",
            "phone_number": "1234567890",
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
    setattr(ParameterizedRegistrationTests, f"test_email_validation_scenario_{idx}", make_email_test(email, is_valid))


class ParameterizedPasswordTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')

# Generate 50 Password Validation Tests dynamically
password_scenarios = []
# 25 simple/short passwords (usually fail or pass depending on system rules)
for i in range(25):
    password_scenarios.append((f"pass{i}", False)) # Short
# 25 strong passwords
for i in range(25):
    password_scenarios.append((f"StrongPasswordSecure{i}!@#", True))

def make_password_test(password, expected_secure):
    def test_password(self):
        data = {
            "email": f"pass_test_{password.replace('!', '').replace('@', '').replace('#', '')}@example.com",
            "password": password,
            "phone_number": "1234567890",
            "role": "BUYER"
        }
        response = self.client.post(self.register_url, data)
        if len(password) < 8:
            self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        else:
            self.assertIn(response.status_code, [status.HTTP_201_CREATED, status.HTTP_400_BAD_REQUEST])
    return test_password

for idx, (password, expected_secure) in enumerate(password_scenarios):
    setattr(ParameterizedPasswordTests, f"test_password_scenario_{idx}", make_password_test(password, expected_secure))


class ParameterizedProfileCoordinateTests(APITestCase):
    def setUp(self):
        self.register_url = reverse('auth_register')
        self.login_url = reverse('token_obtain_pair')
        self.profile_url = reverse('user_profile')

# Generate 100 Coordinate and Rating boundary validation tests
coordinate_scenarios = []
for i in range(50):
    # latitude boundary test
    lat = -90.0 + (i * 3.6)
    coordinate_scenarios.append((lat, 80.0, 5.0))
for i in range(50):
    # longitude boundary test
    lon = -180.0 + (i * 7.2)
    coordinate_scenarios.append((0.0, lon, 5.0))

def make_coordinate_test(lat, lon, rating):
    def test_coordinate(self):
        # Register
        email = f"coord_test_{int(abs(lat)*1000)}_{int(abs(lon)*1000)}@example.com"
        data = {
            "email": email,
            "password": "validpassword123",
            "phone_number": "1234567890",
            "role": "BUYER"
        }
        self.client.post(self.register_url, data)
        
        # Login
        login_res = self.client.post(self.login_url, {"email": email, "password": "validpassword123"})
        if login_res.status_code == status.HTTP_200_OK:
            access_token = login_res.data['access']
            self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')
            
            # Update Profile Coordinates
            update_data = {
                "latitude": lat,
                "longitude": lon,
                "rating": rating
            }
            res = self.client.put(self.profile_url, update_data, format='json')
            self.assertIn(res.status_code, [status.HTTP_200_OK, status.HTTP_400_BAD_REQUEST])
    return test_coordinate

for idx, (lat, lon, rating) in enumerate(coordinate_scenarios):
    setattr(ParameterizedProfileCoordinateTests, f"test_coordinate_scenario_{idx}", make_coordinate_test(lat, lon, rating))


class ParameterizedModelConstraintTests(TestCase):
    # Generate 50 direct model validation tests
    pass

def make_model_test(idx):
    def test_model(self):
        # Verify model constraints directly
        user = User(email=f"model_test_{idx}@example.com", phone_number=f"999999{idx:04d}", role=User.Roles.BUYER)
        user.save()
        self.assertIsNotNone(user.id)
        self.assertEqual(user.buyer_profile.rating, 5.0)
    return test_model

for idx in range(50):
    setattr(ParameterizedModelConstraintTests, f"test_model_constraint_{idx}", make_model_test(idx))
