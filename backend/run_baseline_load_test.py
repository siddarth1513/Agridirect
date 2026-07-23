import os
import sys
import time
import subprocess
import urllib.request
import urllib.error
import pandas as pd

PORT = 8008
TARGET_HOST = f"http://127.0.0.1:{PORT}"

def is_server_running(url=f"{TARGET_HOST}/api/schema/"):
    try:
        req = urllib.request.Request(url, method='GET')
        with urllib.request.urlopen(req, timeout=2) as resp:
            return resp.status < 500
    except urllib.error.HTTPError as e:
        return e.code < 500
    except Exception:
        return False

def main():
    print("==========================================================")
    print("      Farmers App - Baseline / Load Testing Runner        ")
    print("==========================================================")
    print(" Configuration:")
    print("  * Concurrent Virtual Users: 100")
    print("  * Spawn Rate: 20 users / second")
    print("  * Duration: 1 Minute (60 seconds)")
    print(f"  * Target API: {TARGET_HOST}")
    print("==========================================================")

    server_process = None
    print(f"\n[+] Starting multi-threaded Waitress WSGI server on port {PORT}...")
    python_exe = sys.executable
    waitress_exe = os.path.join(os.path.dirname(python_exe), "waitress-serve.exe")
    
    if os.path.exists(waitress_exe):
        server_cmd = [waitress_exe, f"--listen=127.0.0.1:{PORT}", "--threads=16", "config.wsgi:application"]
    else:
        server_cmd = [python_exe, "manage.py", "runserver", f"127.0.0.1:{PORT}", "--nothread"]

    server_process = subprocess.Popen(server_cmd, cwd=os.path.dirname(os.path.abspath(__file__)))
    
    print("    Waiting for server startup & readiness...")
    for i in range(15):
        time.sleep(1)
        if is_server_running():
            print("    Django WSGI server is UP and ready!")
            break
    else:
        print("    Warning: Django server check timed out, proceeding with load test...")

    output_prefix = os.path.join(os.path.dirname(os.path.abspath(__file__)), "baseline_load_results")
    locust_exe = os.path.join(os.path.dirname(sys.executable), "locust.exe")
    if not os.path.exists(locust_exe):
        locust_exe = "locust"

    locust_cmd = [
        locust_exe,
        "-f", "locustfile.py",
        "--headless",
        "-u", "100",
        "-r", "20",
        "--run-time", "1m",
        "--host", TARGET_HOST,
        "--csv", output_prefix
    ]

    print("\n[+] Executing 1-minute Baseline Load Test with 100 users...")
    try:
        res = subprocess.run(locust_cmd, cwd=os.path.dirname(os.path.abspath(__file__)), capture_output=True, text=True)
    finally:
        if server_process:
            print("[+] Terminating temporary Waitress WSGI server...")
            server_process.terminate()
            server_process.wait()

    stats_csv = f"{output_prefix}_stats.csv"
    if os.path.exists(stats_csv):
        df = pd.read_csv(stats_csv)
        print("\n==========================================================")
        print("          BASELINE LOAD TEST PERFORMANCE METRICS          ")
        print("==========================================================")
        
        total_row = df[df['Name'] == 'Aggregated']
        if not total_row.empty:
            total_requests = int(total_row['Request Count'].values[0])
            total_failures = int(total_row['Failure Count'].values[0])
            rps = float(total_row['Requests/s'].values[0])
            avg_ms = float(total_row['Average Response Time'].values[0])
            min_ms = float(total_row['Min Response Time'].values[0])
            max_ms = float(total_row['Max Response Time'].values[0])
            p95_ms = float(total_row['95%'].values[0]) if '95%' in total_row.columns else 0.0

            print(f" Total Requests Sent (1 Min) : {total_requests:,}")
            print(f" Failed Requests            : {total_failures}")
            print(f" Requests Per Second (RPS)  : {rps:.2f} req/sec")
            print(" ----------------------------------------------------------")
            print(" Response Times:")
            print(f"  * Average                 : {avg_ms:.2f} ms")
            print(f"  * Min (Fastest)           : {min_ms:.2f} ms")
            print(f"  * Max (Slowest)           : {max_ms:.2f} ms")
            print(f"  * 95th Percentile         : {p95_ms:.2f} ms")
            print("==========================================================")

            # Export to Excel
            excel_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "baseline_load_test_results.xlsx")
            summary_df = pd.DataFrame([{
                'Test Metric': 'Baseline Load Test (100 Users, 1 Min)',
                'Total Requests': total_requests,
                'Failed Requests': total_failures,
                'Requests Per Second (RPS)': round(rps, 2),
                'Average Response Time (ms)': round(avg_ms, 2),
                'Min Response Time (ms)': round(min_ms, 2),
                'Max Response Time (ms)': round(max_ms, 2),
                '95th Percentile (ms)': round(p95_ms, 2),
            }])
            with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
                summary_df.to_excel(writer, sheet_name='Summary', index=False)
                df.to_excel(writer, sheet_name='Endpoint Breakdown', index=False)
            print(f"\n[OK] Results successfully saved to: {excel_path}\n")
        else:
            print(df)
    else:
        print("[!] Load test completed, but stats file was not generated.")
        print(res.stderr)

if __name__ == '__main__':
    main()
