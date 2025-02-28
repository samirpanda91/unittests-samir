import pytest
from unittest.mock import patch
from your_module import Kafka_sync  # Replace 'your_module' with your actual module name

# Define a real dictionary for configuration
mock_src_config = {
    "kafka_environment": "src_env",
    "topics": ["test_topic"],
    "consumer_group": "test_group",
    "auto_offset": "earliest",
    "filters": {"key1": "value1"},
    "ssl.ca.location": "/path/to/mock/ca.pem",  # Mock SSL certificate path
    "security.protocol": "SSL"
}

mock_dest_config = {
    "kafka_environment": "dest_env",
    "topics": ["test_topic"]
}

mock_aiops_instance = {
    "src": mock_src_config,
    "dest": mock_dest_config
}

@patch("your_module.Aiops_config.get_instance", return_value=mock_aiops_instance)
@patch("your_module.Kafka_Client")  # Replace with the actual Kafka client used
def test_kafka_sync(mock_kafka_client, mock_get_instance):
    """Test Kafka_sync initialization with proper SSL config"""
    
    # Mock Kafka_Client to avoid real Kafka calls
    mock_consumer_instance = mock_kafka_client.return_value
    mock_consumer_instance.AddFilter.return_value = None  # If needed
    
    # Initialize Kafka_sync with a valid config file name (mocked)
    kafka_sync = Kafka_sync("test_config.toml")

    # Assertions to check if Kafka_sync initialized correctly
    assert kafka_sync.src_config == mock_src_config
    assert kafka_sync.dest_config == mock_dest_config
    assert kafka_sync.consumer is not None

    # Ensure Kafka client was called with the correct SSL settings
    mock_kafka_client.assert_called_with("src_env")
    assert "ssl.ca.location" in kafka_sync.src_config
    assert kafka_sync.src_config["ssl.ca.location"] == "/path/to/mock/ca.pem"

@patch("your_module.Aiops_config.get_instance", return_value=mock_aiops_instance)
@patch("your_module.Kafka_Client")
def test_sync_message(mock_kafka_client, mock_get_instance):
    """Test sync_message method"""

    # Mock Kafka Client
    mock_consumer_instance = mock_kafka_client.return_value

    # Initialize Kafka_sync
    kafka_sync = Kafka_sync("test_config.toml")

    # Mock producer dictionary with a simple function
    class MockProducer:
        def write(self, message):
            self.last_message = message  # Store the last written message

    kafka_sync.producers = {"test_topic": MockProducer()}

    # Call sync_message
    mock_partition = type("MockPartition", (object,), {"topic": "test_topic"})()
    kafka_sync.sync_message("test_message", mock_partition)

    # Assertion: Check if producer write() was called
    assert kafka_sync.producers["test_topic"].last_message == "test_message"