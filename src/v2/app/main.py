from os import getenv

import uvicorn
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException, Response
from sqlalchemy.orm import Session

from .db import get_db
from .models import Restaurant

load_dotenv()
app = FastAPI()


podname = getenv("HOSTNAME", "I don't know who I am!")


@app.get("/")
async def root(response: Response):
    response.headers["X-Pod-Name"] = podname
    return {"message": "Hello! I am: " + podname}


@app.get("/health")
async def health(response: Response):
    response.headers["X-Pod-Name"] = podname
    return {"status": "ok"}


# An endpoint to get a general list of restaurants
@app.get("/restaurant")
async def restaurant(response: Response, db: Session = Depends(get_db)):
    response.headers["X-Pod-Name"] = podname
    return db.query(Restaurant).limit(10).all()


@app.get("/restaurant/{id}")
async def restaurant_by_id(response: Response, id: int, db: Session = Depends(get_db)):
    response.headers["X-Pod-Name"] = podname
    restaurant = db.query(Restaurant).get(id)
    if restaurant is None:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    return restaurant


if __name__ == "__main__":
    port = getenv("FASTAPI_PORT", 8000)
    try:
        port = int(port)
    except ValueError:
        port = 8000

    uvicorn.run(app, host="0.0.0.0", port=port)
