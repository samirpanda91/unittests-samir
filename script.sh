import pytest
from unittest.mock import AsyncMock, patch
from your_module import YourClass  # Replace with actual import

@pytest.mark.asyncio
async def test_main():
    instance = YourClass()  # Instantiate the class
    instance.sync_data = AsyncMock()  # Mock sync_data function
    
    mock_crontab = patch("aiocron.crontab").start()  # Mock aiocron.crontab

    with patch("your_module.constants.TABLES_TO_SYNC", ["APPLICATION", "OTHER_TABLE"]):  
        await instance.main()  # Call the main function

        # Check if crontab was called with expected arguments
        mock_crontab.assert_any_call(
            "0 20 * * *", func=instance.sync_data, args=("APPLICATION_ENRICHMENT",), start=True
        )
        mock_crontab.assert_any_call(
            "*/10 * * * *", func=instance.sync_data, args=("OTHER_TABLE_ENRICHMENT",), start=True
        )

    mock_crontab.stop()