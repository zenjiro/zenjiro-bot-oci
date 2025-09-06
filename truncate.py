import sys
import unicodedata

try:
    from twitter_text import parse_tweet
except Exception:
    parse_tweet = None


def weighted_length(text: str) -> int:
    if parse_tweet is not None:
        try:
            r = parse_tweet(text)
            if isinstance(r, dict):
                return r.get("weightedLength") or r.get("weighted_length") or 0
        except Exception:
            pass
    return sum(2 if unicodedata.east_asian_width(ch) in "FWA" else 1 for ch in text)


if __name__ == "__main__":
    s = sys.stdin.read()
    if s.endswith("\n"):
        s = s[:-1]
    while s and weighted_length(s) > 280:
        s = s[:-1]
    print(s)
