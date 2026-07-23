import random
import string
from locust import HttpUser, task, between

class FarmersAppLoadTest(HttpUser):
    """
    Simulates a user interacting with the Farmers App backend.
    Focuses on authentication and typical API usage.
    """
    
    # Simulate active concurrent user traffic with short think times
    wait_time = between(0.1, 0.5)

    def on_start(self):
        """
        Called when a Locust user starts before any tasks are scheduled.
        We can register and login a user here to get an auth token.
        """
        random_str = ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))
        self.email = f"load_user_{random_str}@example.com"
        self.password = "StrongPasswordSecure123!"
        
        # 1. Register the user
        self.client.post("/api/auth/register/", json={
            "email": self.email,
            "password": self.password,
            "phone_number": f"+1{random.randint(100000000, 999999999)}",
            "role": "BUYER"
        }, name="/api/auth/register/")
        
        # 2. Login to get token
        response = self.client.post("/api/auth/login/", json={
            "email": self.email,
            "password": self.password
        }, name="/api/auth/login/")
        
        if response.status_code == 200:
            token = response.json().get('access')
            if token:
                # Set authorization header for future requests
                self.client.headers.update({"Authorization": f"Bearer {token}"})

    @task(3)
    def login_task(self):
        """Simulate users logging in repeatedly."""
        self.client.post("/api/auth/login/", json={
            "email": self.email,
            "password": self.password
        }, name="/api/auth/login/")

    @task(1)
    def invalid_login_task(self):
        """Simulate a failed login attempt."""
        self.client.post("/api/auth/login/", json={
            "email": self.email,
            "password": "WrongPassword!"
        }, name="/api/auth/login/ [invalid]")
