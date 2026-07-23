from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

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
