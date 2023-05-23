from os import getenv

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI

load_dotenv()
app = FastAPI()


@app.get("/")
async def root():
    return {"message": getenv("POD_MSG", "Hello World!")}


if __name__ == "__main__":
    port = getenv("FASTAPI_PORT", 8000)
    try:
        port = int(port)
    except ValueError:
        port = 8000

    uvicorn.run(app, host="0.0.0.0", port=port)
