import sys
from twitter_text import parse_tweet

s = "".join(sys.stdin.readlines()).rstrip()
for i in range(0, len(s)):
    if parse_tweet(s[:-i]).weightedLength <= 280:
        print(s[:-i])
        break
