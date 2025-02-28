import pytest
import tempfile
import os
from unittest.mock import patch, MagicMock
from your_module import Kafka_sync  # Replace 'your_module' with the actual module name

# Function to generate a mock config
def get_mock_config(fake_cert_path, disable_ssl=False):
    config = {
        "kafka_environment": "src_env",
        "topics": ["test_topic"],
        "consumer_group": "test_group",
        "auto_offset": "earliest",
        "filters": {"key1": "value1"},
        "ssl.ca.location": fake_cert_path,  # Temporary cert path
        "security.protocol": "SSL"
    }
    if disable_ssl:
        config.pop("ssl.ca.location", None)  # Remove SSL for testing
    return config

# Fixture to create a temporary SSL certificate
@pytest.fixture
def temp_ssl_cert():
    """Creates a temporary SSL certificate file."""
    with tempfile.NamedTemporaryFile(delete=False) as temp_cert:
        temp_cert.write(b"Fake SSL Certificate")  # Write fake content
        temp_cert_path = temp_cert.name  # Store the file path
    yield temp_cert_path  # Provide file path to the test
    os.remove(temp_cert_path)  # Cleanup after test

# Mock Aiops_config to return the test configuration
@pytest.fixture
def mock_aiops_config(temp_ssl_cert):
    return {
        "src": get_mock_config(temp_ssl_cert),
        "dest": {"kafka_environment": "dest_env", "topics": ["test_topic"]}
    }

# Test Kafka_sync initialization with a temporary SSL cert
@patch("your_module.Aiops_config.get_instance")
@patch("your_module.Kafka_Client")  # Mock Kafka Client
def test_kafka_sync(mock_kafka_client, mock_get_instance, temp_ssl_cert, mock_aiops_config):
    """Test Kafka_sync initialization with a temporary SSL cert."""
    
    # Mock Aiops_config
    mock_get_instance.return_value = mock_aiops_config

    # Mock Kafka Client
    mock_kafka_client.return_value = MagicMock()

    # Initialize Kafka_sync
    kafka_sync = Kafka_sync("test_config.toml")

    # Assertions
    assert kafka_sync.src_config["ssl.ca.location"] == temp_ssl_cert
    assert os.path.exists(temp_ssl_cert)  # Ensure the file exists
    mock_kafka_client.assert_called_with("src_env")

# Test Kafka_sync without SSL (disable_ssl=True)
@patch("your_module.Aiops_config.get_instance")
@patch("your_module.Kafka_Client")
def test_kafka_sync_no_ssl(mock_kafka_client, mock_get_instance, mock_aiops_config):
    """Test Kafka_sync initialization without SSL."""
    
    # Mock Aiops_config with SSL disabled
    mock_get_instance.return_value = {
        "src": get_mock_config(None, disable_ssl=True),  # Remove SSL
        "dest": {"kafka_environment": "dest_env", "topics": ["test_topic"]}
    }

    # Mock Kafka Client
    mock_kafka_client.return_value = MagicMock()

    # Initialize Kafka_sync with SSL disabled
    kafka_sync = Kafka_sync("test_config.toml", disable_ssl=True)

    # Assertions
    assert "ssl.ca.location" not in kafka_sync.src_config  # SSL should be disabled
    mock_kafka_client.assert_called_with("src_env")

# Test sync_message method
@patch("your_module.Aiops_config.get_instance")
@patch("your_module.Kafka_Client")
def test_sync_message(mock_kafka_client, mock_get_instance, temp_ssl_cert, mock_aiops_config):
    """Test sync_message method of Kafka_sync."""

    # Mock Aiops_config
    mock_get_instance.return_value = mock_aiops_config

    # Mock Kafka Client
    mock_consumer_instance = mock_kafka_client.return_value
    mock_consumer_instance.AddFilter.return_value = None

    # Initialize Kafka_sync
    kafka_sync = Kafka_sync("test_config.toml")

    # Mock producer dictionary
    class MockProducer:
        def __init__(self):
            self.last_message = None
        
        def write(self, message):
            self.last_message = message  # Store the last written message

    kafka_sync.producers = {"test_topic": MockProducer()}

    # Call sync_message
    mock_partition = type("MockPartition", (object,), {"topic": "test_topic"})()
    kafka_sync.sync_message("test_message", mock_partition)

    # Assertions
    assert kafka_sync.producers["test_topic"].last_message == "test_message"