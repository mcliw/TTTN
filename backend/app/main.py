from fastapi import FastAPI
from app.api import router

app = FastAPI(title="Chatbot TLU Backend")

app.include_router(router)

@app.get("/")
def root():
    return {"message": "Hello from Chatbot TLU backend"}
