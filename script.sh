from unittest.mock import patch, MagicMock
from aiops_purl.request_handler import RequestHandler  # Adjust import based on your project

@patch("requests.put")
def test_put(mock_put):
    """Test PUT request execution with type assertions"""
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.text = "Put Response"
    mock_put.return_value = mock_response

    request_handler = RequestHandler()
    request_handler._json_post_data = {"key": "value"}  # Ensure it's not empty
    request_handler._request_params = {"url": "http://example.com"}

    result = request_handler._put()

    assert isinstance(result, str)
    assert result == "Put Response"
    assert mock_put.call_count == 1
    mock_put.assert_called_once_with(**request_handler._request_params)


@patch("requests.patch")
def test_patch(mock_patch):
    """Test PATCH request execution with type assertions"""
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.text = "Patch Response"
    mock_patch.return_value = mock_response

    request_handler = RequestHandler()
    request_handler._json_post_data = {"key": "update"}
    request_handler._request_params = {"url": "http://example.com"}

    result = request_handler._patch()

    assert isinstance(result, str)
    assert result == "Patch Response"
    assert mock_patch.call_count == 1
    mock_patch.assert_called_once_with(**request_handler._request_params)


@patch("requests.delete")
def test_delete(mock_delete):
    """Test DELETE request execution with type assertions"""
    mock_response = MagicMock()
    mock_response.status_code = 204
    mock_response.text = "Delete Response"
    mock_delete.return_value = mock_response

    request_handler = RequestHandler()
    request_handler._json_post_data = {"key": "remove"}
    request_handler._request_params = {"url": "http://example.com"}

    result = request_handler._delete()

    assert isinstance(result, str)
    assert result == "Delete Response"
    assert mock_delete.call_count == 1
    mock_delete.assert_called_once_with(**request_handler._request_params)


@patch("requests.post")
def test_post(mock_post):
    """Test POST request execution with type assertions"""
    mock_response = MagicMock()
    mock_response.status_code = 201
    mock_response.text = "Post Response"
    mock_post.return_value = mock_response

    request_handler = RequestHandler()
    request_handler._json_post_data = {"key": "new_data"}
    request_handler._request_params = {"url": "http://example.com"}

    result = request_handler._post()

    assert isinstance(result, str)
    assert result == "Post Response"
    assert mock_post.call_count == 1
    mock_post.assert_called_once_with(**request_handler._request_params)


@patch("requests.request")
def test_execute_request(mock_request):
    """Test general request execution with type assertions"""
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.text = "Execute Response"
    mock_request.return_value = mock_response

    request_handler = RequestHandler()
    request_handler._request_type = "GET"
    request_handler._request_params = {"url": "http://example.com"}

    result = request_handler.Execute_request()

    assert isinstance(result, str)
    assert result == "Execute Response"
    assert mock_request.call_count == 1
    mock_request.assert_called_once_with(
        request_handler._request_type, **request_handler._request_params
    )