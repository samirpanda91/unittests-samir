import pytest
from unittest.mock import patch
from your_module import Kafka_sync  # Replace 'your_module' with your actual module name

# Define a real dictionary for configuration
mock_src_config = {
    "kafka_environment": "src_env",
    "topics": ["test_topic"],
    "consumer_group": "test_group",
    "auto_offset": "earliest",
    "filters": {"key1": "value1"}
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
def test_kafka_sync(mock_get_instance):
    # Initialize Kafka_sync with a valid config file name (mocked)
    kafka_sync = Kafka_sync("test_config.toml")

    # Assertions to check if Kafka_sync initialized correctly
    assert kafka_sync.src_config == mock_src_config
    assert kafka_sync.dest_config == mock_dest_config
    assert kafka_sync.consumer is not None
    assert kafka_sync.producers is not None

@patch("your_module.Aiops_config.get_instance", return_value=mock_aiops_instance)
def test_sync_message(mock_get_instance):
    # Initialize Kafka_sync
    kafka_sync = Kafka_sync("test_config.toml")

    # Mock producer dictionary with a real function
    class MockProducer:
        def write(self, message):
            self.last_message = message  # Store the last written message

    kafka_sync.producers = {"test_topic": MockProducer()}

    # Call sync_message
    mock_partition = type("MockPartition", (object,), {"topic": "test_topic"})()
    kafka_sync.sync_message("test_message", mock_partition)

    # Assertion: Check if producer write() was called
    assert kafka_sync.producers["test_topic"].last_message == "test_message"