import sys
from twitter_text import parse_tweet

s = "".join(sys.stdin.readlines()).rstrip()
for i in range(0, len(s) + 1):
    t = s if i == 0 else s[:-i]
    if parse_tweet(t).weightedLength <= 280:
        print(t)
        break
