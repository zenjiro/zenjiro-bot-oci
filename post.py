import os
import sys

import twikit

screen_name = sys.argv[1]
message = sys.stdin.read()
client = twikit.Client("ja-jp")
try:
    client.load_cookies(f".{screen_name.lower()}.json")
    client.create_tweet(message)
except (twikit.errors.Unauthorized, FileNotFoundError):
    client = twikit.Client("ja-jp")
    client.login(
        auth_info_1=screen_name,
        auth_info_2=os.getenv(f"{screen_name.lower()}_EMAIL"),
        password=os.getenv(f"{screen_name.lower()}_PASSWORD"),
    )
    client.save_cookies(f".{screen_name.lower()}.json")
    client.create_tweet(message)
