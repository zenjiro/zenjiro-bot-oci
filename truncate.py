import sys
from twitter_text import parse_tweet

if __name__ == "__main__":
    s = sys.stdin.read()
    if s.endswith("\n"):
        s = s[:-1]
    while True:
        r = parse_tweet(s)
        if getattr(r, "weightedLength", None) is not None:
            length = r.weightedLength
        else:
            # Fallback to dict-style just in case some builds return a mapping
            try:
                length = r["weightedLength"]
            except Exception:
                length = 0
        if length <= 280:
            break
        s = s[:-1]
    print(s)
