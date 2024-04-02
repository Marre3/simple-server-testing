#!/usr/bin/env python3

import requests

req = requests.get(
    url="http://localhost:3000/get"
)
if req.status_code == 200:
    if req.headers["content-type"].startswith("application/json"):
        for msg in req.json()["messages"]:
            print(f"{msg["user"]}: {msg["message"]}")
    else:
        print(req.headers)
