from os import getenv

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI

load_dotenv()
app = FastAPI()


if __name__ == "__main__":
    port = getenv("FASTAPI_PORT", 8080)
    try:
        port = int(port)
    except ValueError:
        port = 8080

    uvicorn.run(app, host="0.0.0.0", port=port)
