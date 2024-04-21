import sys

import twikit

client = twikit.Client("ja-jp")
client.load_cookies(f".{sys.argv[1].lower()}.json")
client.create_tweet(sys.stdin.read())
