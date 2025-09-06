import sys
from twitter_text import parse_tweet

s = "".join(sys.stdin.readlines())
for i in range(1, len(s)):
    if parse_tweet(s[:-i]).weightedLength <= 280:
        print(s[:-i])
        break
