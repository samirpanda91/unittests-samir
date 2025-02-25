import pytest
from aiops_purl.version import __version__

def test_version():
    assert isinstance(__version__, str)
    assert __version__ == "0.5.2"

def test_main_print_output(capfd):
    """Test the output of `if __name__ == '__main__'` block"""
    from aiops_purl.version import __name__ as module_name

    if module_name == "__main__":
        print(__version__)

    captured = capfd.readouterr()  # Capture printed output
    assert captured.out.strip() == "0.5.2"