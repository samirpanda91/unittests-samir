import pytest
from unittest.mock import MagicMock, patch
from your_module import Kafka_sync  # Replace 'your_module' with the actual module name

# Mock configuration for source and destination
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

@patch("your_module.Aiops_config")  # Replace 'your_module' with the actual module where Aiops_config is used
def test_kafka_sync(mock_aiops_config):
    # Mock Aiops_config behavior
    mock_aiops_instance = MagicMock()
    mock_aiops_instance.get_instance.return_value = {
        "src": mock_src_config,
        "dest": mock_dest_config
    }
    mock_aiops_config.return_value = mock_aiops_instance

    # Initialize Kafka_sync with a valid config file name (mocked)
    kafka_sync = Kafka_sync("test_config.toml")

    # Assertions to check if Kafka_sync initialized correctly
    assert kafka_sync.src_config == mock_src_config
    assert kafka_sync.dest_config == mock_dest_config
    assert kafka_sync.consumer is not None
    assert kafka_sync.producers is not None

@patch("your_module.Aiops_config")
def test_sync_message(mock_aiops_config):
    mock_aiops_instance = MagicMock()
    mock_aiops_instance.get_instance.return_value = {
        "src": mock_src_config,
        "dest": mock_dest_config
    }
    mock_aiops_config.return_value = mock_aiops_instance

    # Initialize Kafka_sync
    kafka_sync = Kafka_sync("test_config.toml")

    # Mock producer
    kafka_sync.producers = {"test_topic": MagicMock()}

    # Call sync_message
    mock_partition = MagicMock()
    mock_partition.topic = "test_topic"
    kafka_sync.sync_message("test_message", mock_partition)

    # Assertion: Check if producer write() was called
    assert kafka_sync.producers["test_topic"].write.called