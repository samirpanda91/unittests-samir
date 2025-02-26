import re
import os

def read_env(self):
    self._load_explicit_env_vars()
    self._load_regex_env_vars()

def _load_explicit_env_vars(self):
    """Load explicitly defined environment variables."""
    env_vars = self.config.get("environment", {}).get("env", [])
    for var in env_vars:
        value = os.environ.get(var)
        if value is not None:
            self.__setitem__(var, value)

def _load_regex_env_vars(self):
    """Load environment variables matching a regex, excluding explicitly set ones."""
    env_rex = self.config.get("environment", {}).get("env_rex")
    if not env_rex:
        return  # No regex pattern, nothing to process

    for var in os.environ:
        if var not in self.config and re.match(env_rex, var):
            self.__setitem__(var, os.environ[var])