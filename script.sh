import subprocess
import sys
from pathlib import Path

def test_version():
    from aiops_purl.version import __version__
    assert isinstance(__version__, str)
    assert __version__ == "0.5.2"

def test_main_print_output():
    """Test the output of `if __name__ == '__main__'` block"""
    script_path = Path(__file__).parent.parent / "aiops_purl" / "version.py"

    result = subprocess.run([sys.executable, str(script_path)], capture_output=True, text=True)

    assert result.returncode == 0  # Ensure the script runs successfully
    assert result.stdout.strip() == "0.5.2"  # Check expected output