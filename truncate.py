import sys
from twitter_text import parse_tweet

s = sys.stdin.read().rstrip("\n")
for i in range(0, len(s) + 1):
    candidate = s if i == 0 else s[:-i]
    if parse_tweet(candidate).weightedLength <= 280:
        print(candidate)
        break
