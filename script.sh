import pytest
from unittest.mock import patch, MagicMock
from aiops_purl.request_handler import RequestHandler  # Update with actual module

@pytest.fixture
def request_handler():
    return RequestHandler()

@pytest.mark.parametrize("creds, headers, proxies, timeout, params", [
    ([], {}, {}, None, {}),  # No optional parameters
    (["user", "pass"], {"Content-Type": "application/json"}, {"http": "proxy"}, 30, {"key": "value"}),
])
def test_execute_request(request_handler, creds, headers, proxies, timeout, params):
    request_handler._creds = creds
    request_handler._headers = headers
    request_handler._proxies = proxies
    request_handler._timeout = timeout
    request_handler._params = params
    request_handler.url = "http://example.com"
    request_handler._request_type = "_post"  # Simulating a POST request
    request_handler._requestAction = {"_post": lambda: "Success"}

    result = request_handler.Execute_request()
    assert result == "Success"


@pytest.mark.parametrize("method", ["_put", "_patch", "_delete", "_post"])
@patch("requests.put")
@patch("requests.patch")
@patch("requests.delete")
@patch("requests.post")
def test_http_methods(mock_post, mock_delete, mock_patch, mock_put, request_handler, method):
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.text = "Response"
    
    mock_put.return_value = mock_response
    mock_patch.return_value = mock_response
    mock_delete.return_value = mock_response
    mock_post.return_value = mock_response

    request_handler._json_post_data = {"key": "value"}
    request_handler._request_params = {"url": "http://example.com"}

    method_func = getattr(request_handler, method)
    result = method_func()

    assert result == mock_response.text

    if method == "_put":
        mock_put.assert_called_once_with(**request_handler._request_params)
    elif method == "_patch":
        mock_patch.assert_called_once_with(**request_handler._request_params)
    elif method == "_delete":
        mock_delete.assert_called_once_with(**request_handler._request_params)
    elif method == "_post":
        mock_post.assert_called_once_with(**request_handler._request_params)