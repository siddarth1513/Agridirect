import os
import sys
import time
import django
import pandas as pd
from unittest import TextTestResult, TextTestRunner, defaultTestLoader

# Initialize Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

class ExcelTestResult(TextTestResult):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.results_list = []

    def startTest(self, test):
        self._start_time = time.time()
        super().startTest(test)

    def addSuccess(self, test):
        elapsed = time.time() - self._start_time
        doc = test.shortDescription() or test._testMethodDoc
        self.results_list.append({
            'Test ID': test.id(),
            'Test Name': test._testMethodName,
            'Class': test.__class__.__name__,
            'Description': doc.strip() if doc else "No description available",
            'Status': 'PASSED',
            'Execution Time (s)': round(elapsed, 4),
            'Error Message': ''
        })
        super().addSuccess(test)

    def addFailure(self, test, err):
        elapsed = time.time() - self._start_time
        doc = test.shortDescription() or test._testMethodDoc
        self.results_list.append({
            'Test ID': test.id(),
            'Test Name': test._testMethodName,
            'Class': test.__class__.__name__,
            'Description': doc.strip() if doc else "No description available",
            'Status': 'FAILED',
            'Execution Time (s)': round(elapsed, 4),
            'Error Message': self._exc_info_to_string(err, test)
        })
        super().addFailure(test, err)

    def addError(self, test, err):
        elapsed = time.time() - self._start_time
        doc = test.shortDescription() or test._testMethodDoc
        self.results_list.append({
            'Test ID': test.id(),
            'Test Name': test._testMethodName,
            'Class': test.__class__.__name__,
            'Description': doc.strip() if doc else "No description available",
            'Status': 'ERROR',
            'Execution Time (s)': round(elapsed, 4),
            'Error Message': self._exc_info_to_string(err, test)
        })
        super().addError(test, err)

def main():
    print("====================================================")
    print("Starting Django & Selenium Comprehensive Test Suite")
    print("====================================================")
    
    # Configure Django for test execution (e.g., set settings database to sqlite3)
    from django.conf import settings
    # Ensure settings.DATABASES is switched to testing DB or sqlite
    
    # Discover and load tests from accounts app
    suite = defaultTestLoader.discover('accounts', pattern='tests.py')
    
    # Setup the Django test environment
    from django.test.utils import setup_test_environment, teardown_test_environment
    from django.db import connection
    
    setup_test_environment()
    
    # Create the test database
    db_name = connection.creation.create_test_db(verbosity=1, keepdb=False, serialize=False)
    
    # Custom test runner using our ExcelTestResult
    class ExcelTestRunner(TextTestRunner):
        def _makeResult(self):
            return ExcelTestResult(self.stream, self.descriptions, self.verbosity)
            
    runner = ExcelTestRunner(verbosity=2)
    start_time = time.time()
    result = runner.run(suite)
    end_time = time.time()
    
    # Tear down the test database
    connection.creation.destroy_test_db(db_name, verbosity=1)
    teardown_test_environment()
    
    # Export results to Excel
    print("\nWriting results to Excel sheet...")
    df = pd.DataFrame(result.results_list)
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'test_results.xlsx')
    
    # Style and write using Excel
    with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Test Runs')
        
    print(f"Results successfully saved to: {output_path}")
    print(f"Total Tests Executed: {len(df)}")
    print(f"Passed: {len(df[df['Status'] == 'PASSED'])}")
    print(f"Failed: {len(df[df['Status'] == 'FAILED'])}")
    print(f"Errors: {len(df[df['Status'] == 'ERROR'])}")
    print(f"Total Execution Time: {round(end_time - start_time, 2)} seconds")
    print("====================================================")

if __name__ == '__main__':
    main()
