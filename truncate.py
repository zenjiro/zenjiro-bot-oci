import sys
from twitter_text import parse_tweet

s = sys.stdin.read().rstrip()
for i in range(len(s), -1, -1):
    if parse_tweet(s[:i]).weightedLength <= 280:
        print(s[:i])
        break
