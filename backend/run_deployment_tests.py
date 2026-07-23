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
    print("Starting Django Production Deployment Readiness Suite")
    print("====================================================")
    
    # Discover and load tests from accounts app specifically for deployment_tests.py
    suite = defaultTestLoader.discover('accounts', pattern='deployment_tests.py')
    
    # Setup the Django test environment
    from django.test.utils import setup_test_environment, teardown_test_environment
    setup_test_environment()
    
    # Custom test runner using our ExcelTestResult
    class ExcelTestRunner(TextTestRunner):
        def _makeResult(self):
            return ExcelTestResult(self.stream, self.descriptions, self.verbosity)
            
    runner = ExcelTestRunner(verbosity=2)
    start_time = time.time()
    result = runner.run(suite)
    end_time = time.time()
    
    teardown_test_environment()
    
    # Export results to Excel
    print("\nWriting deployment readiness results to Excel sheet...")
    df = pd.DataFrame(result.results_list)
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'deployment_test_results.xlsx')
    
    # Style and write using Excel
    with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Deployment Checklist')
        
    print(f"Results successfully saved to: {output_path}")
    print(f"Total Deployment Checks Executed: {len(df)}")
    print(f"Passed: {len(df[df['Status'] == 'PASSED'])}")
    print(f"Failed: {len(df[df['Status'] == 'FAILED'])}")
    print(f"Errors: {len(df[df['Status'] == 'ERROR'])}")
    print(f"Total Execution Time: {round(end_time - start_time, 2)} seconds")
    print("====================================================")

if __name__ == '__main__':
    main()
