import os
import sys

import twikit

screen_name = sys.argv[1]
message = sys.stdin.read()
client = twikit.Client("ja-jp")
client.load_cookies(f".{screen_name.lower()}.json")
client.create_tweet(message)
