#!/usr/bin/env python3

import logging
import requests
logger = logging.getLogger(__name__)

name = input("Enter your name: ")
while True:
    msg = input()
    try:
        r = requests.post(
            url="http://localhost:3000/send",
            json={"user": name, "message": msg},
        )
        print(r)
    except requests.exceptions.RequestException:
        logger.exception("Connection failed")
