import pytest
import json
from unittest.mock import patch
import requests
from main import callhome  # Import the function from your main script

# Mock URL
mock_url = "https://ca02726-orchestra-callhome-service-dev.apps.cic-lmr-n-01.cf.wellsfargo.com"

@pytest.fixture
def mock_post():
    """Fixture to mock requests.post"""
    with patch("requests.post") as mock_request:
        yield mock_request

def test_callhome_success(mock_post):
    """Test callhome function for a successful API response"""
    mock_response = requests.Response()
    mock_response.status_code = 200
    mock_post.return_value = mock_response

    status_code = callhome()
    
    # Assertions
    mock_post.assert_called_once()  # Ensure the API was called once
    assert mock_post.call_args[0][0] == mock_url  # Check if correct URL was used
    assert mock_post.call_args[1]["headers"] == {'Content-Type': 'application/json'}  # Check headers
    assert status_code == 200  # Validate response

def test_callhome_failure(mock_post):
    """Test callhome function when API request fails"""
    mock_post.side_effect = requests.exceptions.RequestException("API failure")

    status_code = callhome()

    # Since exception is caught, function should not raise an error but print "request failed"
    assert status_code is None