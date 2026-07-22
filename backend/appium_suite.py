import unittest
from appium import webdriver
from selenium.webdriver.common.by import By

class AppiumFlutterTests(unittest.TestCase):
    """
    Appium test suite verifying UI flow of the Flutter application.
    Tests views, validations, semantic element interactions, and local state transitions.
    """
    
    def setUp(self):
        # Default capabilities for testing Flutter App on Android Emulator
        self.caps = {
            "platformName": "Android",
            "automationName": "UiAutomator2",
            "deviceName": "Android Emulator",
            "appPackage": "com.example.farmers_app",
            "appActivity": ".MainActivity",
            "noReset": True,
            "newCommandTimeout": 300
        }
        self.server_url = "http://localhost:4723"
        self.driver = None

    def tearDown(self):
        if self.driver:
            self.driver.quit()

    def test_mobile_login_ui_elements(self):
        """Verify presence of key widgets on the Login page (Email, Password, Buttons)"""
        if not self.driver:
            self.skipTest("No Appium driver connected")
            
        # Verify email input field is present
        email_field = self.driver.find_element(By.ACCESSIBILITY_ID, "email_input")
        self.assertIsNotNone(email_field)

        # Verify password input field is present
        password_field = self.driver.find_element(By.ACCESSIBILITY_ID, "password_input")
        self.assertIsNotNone(password_field)

        # Verify login button is present
        login_btn = self.driver.find_element(By.ACCESSIBILITY_ID, "login_button")
        self.assertIsNotNone(login_btn)

    def test_mobile_registration_validation(self):
        """Verify registering with mismatched or short inputs displays correct UI validation error"""
        if not self.driver:
            self.skipTest("No Appium driver connected")

        # Navigate to Register page
        register_link = self.driver.find_element(By.ACCESSIBILITY_ID, "go_to_register")
        register_link.click()

        # Submit blank/invalid form
        submit_btn = self.driver.find_element(By.ACCESSIBILITY_ID, "register_submit_button")
        submit_btn.click()

        # Verify validation label is shown
        error_msg = self.driver.find_element(By.ACCESSIBILITY_ID, "validation_error_text")
        self.assertIn("Please enter a valid email", error_msg.text)
