import pytest
from unittest.mock import AsyncMock
from your_module import YourClass  # Replace with actual module and class

@pytest.mark.asyncio
async def test_suppression_enrichment():
    instance = YourClass()  # Instantiate the class
    
    mock_mongo = AsyncMock()  # Mock MongoDB collection
    row = {
        "suppression_record": "record_123",
        "start_date_time": "2025-03-13T12:00:00Z",
        "end_date_time": "2025-03-13T14:00:00Z",
        "start_time": "12.5",
        "suppression_duration": "90.0",
        "modified_datetime": "2025-03-13T15:00:00Z",
        "extra_field": None,  # Should be filtered out
    }

    await instance.suppression_enrichment(row, mock_mongo)

    expected_query = {"suppression_record": "record_123"}
    expected_row = {
        "suppression_record": "record_123",
        "start_date_time": "2025-03-13T12:00:00Z",
        "end_date_time": "2025-03-13T14:00:00Z",
        "start_time": 12.5,
        "suppression_duration": 90.0,
        "modified_datetime": "2025-03-13T15:00:00Z",
    }

    # Ensure upsert was called with the correct query and filtered row
    mock_mongo.upsert.assert_called_once_with(expected_query, expected_row, upsert=True)