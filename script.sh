import subprocess
import sys
from pathlib import Path

def test_main_execution():
    script_path = Path(__file__).parent.parent / "aiops_purl" / "version.py"
    result = subprocess.run([sys.executable, str(script_path)], capture_output=True, text=True)
    
    assert result.returncode == 0  # Ensure script runs successfully
    assert result.stdout.strip() == "0.5.2"  # Check expected output