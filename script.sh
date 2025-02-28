import pytest
from unittest.mock import MagicMock
from your_module import Kafka_sync  # Replace `your_module` with the actual module name

def test_kafka_sync():
    # Mock config values
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

    # Mock AIOps config
    mock_aiops_config = MagicMock()
    mock_aiops_config.get_instance.return_value = {
        "src": mock_src_config,
        "dest": mock_dest_config
    }

    # Initialize Kafka_sync
    kafka_sync = Kafka_sync(mock_aiops_config)

    # Assertions for initialization
    assert kafka_sync.src_config == mock_src_config
    assert kafka_sync.dest_config == mock_dest_config
    assert kafka_sync.consumer is not None
    assert kafka_sync.producers is not None

def test_sync_message():
    kafka_sync = Kafka_sync(MagicMock())

    # Mock producer
    kafka_sync.producers = {"test_topic": MagicMock()}
    
    # Call sync_message
    kafka_sync.sync_message("test_message", MagicMock(topic="test_topic"))

    # Assertion: Check if producer write() was called
    assert kafka_sync.producers["test_topic"].write.called