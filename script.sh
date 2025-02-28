from unittest.mock import patch, MagicMock
from confluent_kafka import Consumer

@patch("confluent_kafka.Consumer", autospec=True)
def test_kafka_consumer(mock_consumer):
    mock_instance = MagicMock()
    mock_consumer.return_value = mock_instance
    
    config = {"group.id": "test-group"}
    consumer = Consumer(config)
    
    assert consumer is not None
    mock_consumer.assert_called_once()