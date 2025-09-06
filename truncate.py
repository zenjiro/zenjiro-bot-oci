import sys
from twitter_text import parse_tweet

if __name__ == "__main__":
    s = sys.stdin.read()
    if s.endswith("\n"):
        s = s[:-1]
    while True:
        r = parse_tweet(s)
        if r.weightedLength <= 280:
            break
        s = s[:-1]
    print(s)
