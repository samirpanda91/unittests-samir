import requests
from requests_ntlm import HttpNtlmAuth
import snowflake.connector

# Proxy configuration
proxy_url = 'http://your-proxy-server:port'  # Replace with your proxy server
proxy_username = 'DOMAIN\\username'  # Replace with your AD username (format: DOMAIN\username)
proxy_password = 'your-password'  # Replace with your AD password

# Snowflake connection details
snowflake_user = 'your-snowflake-username'
snowflake_password = 'your-snowflake-password'
snowflake_account = 'your-account'  # Replace with your Snowflake account identifier
snowflake_warehouse = 'your-warehouse'
snowflake_database = 'your-database'
snowflake_schema = 'your-schema'
snowflake_role = 'your-role'

# Target URL to test the proxy (Snowflake endpoint)
target_url = f'https://{snowflake_account}.snowflakecomputing.com'

# Step 1: Verify Proxy with AD Credentials
def verify_proxy():
    print("Verifying proxy with AD credentials...")
    session = requests.Session()
    session.proxies = {
        'http': proxy_url,
        'https': proxy_url,
    }
    session.auth = HttpNtlmAuth(proxy_username, proxy_password)

    try:
        response = session.get(target_url)
        print("Proxy verification successful!")
        print("Status Code:", response.status_code)
        return True
    except requests.exceptions.RequestException as e:
        print("Proxy verification failed:", e)
        return False

# Step 2: Connect to Snowflake Using Proxy
def connect_to_snowflake():
    print("Connecting to Snowflake...")
    try:
        # Configure the Snowflake Connector to use the proxy
        conn = snowflake.connector.connect(
            user=snowflake_user,
            password=snowflake_password,
            account=snowflake_account,
            warehouse=snowflake_warehouse,
            database=snowflake_database,
            schema=snowflake_schema,
            role=snowflake_role,
            proxy=proxy_url  # Pass the proxy configuration
        )

        # Test the connection
        cursor = conn.cursor()
        cursor.execute("SELECT CURRENT_VERSION()")
        result = cursor.fetchone()
        print("Snowflake Version:", result[0])
        cursor.close()
        conn.close()
    except snowflake.connector.errors.Error as e:
        print("Failed to connect to Snowflake:", e)

# Main Execution
if __name__ == "__main__":
    if verify_proxy():
        connect_to_snowflake()