import os
import sys
from dotenv import load_dotenv

def main() -> None:
    """
    Loads environment variables from .env and starts the LiteLLM proxy server.
    """
    # 1. Load environment variables from .env file
    load_dotenv()

    # 2. Check if key loaded correctly (Optional sanity check)
    if not os.getenv("AZURE_API_KEY"):
        print("Error: AZURE_API_KEY not found in .env file.")
        sys.exit(1)

    proxy_config = "config.yaml"
    
    # 3. Start LiteLLM
    print(f"Starting LiteLLM Proxy on http://0.0.0.0:4000 using {proxy_config}")
    os.system(f"litellm --config {proxy_config} --port 4000")

if __name__ == "__main__":
    main()