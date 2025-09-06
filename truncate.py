import sys
import unicodedata

try:
    from twitter_text import parse_tweet  # provided by twitter-text-python
except Exception:  # pragma: no cover
    parse_tweet = None


def weighted_length(text: str) -> int:
    if parse_tweet is not None:
        try:
            res = parse_tweet(text)
            # Prefer camelCase key if present (common in ports), else snake_case
            if isinstance(res, dict):
                return res.get("weightedLength") or res.get("weighted_length") or 0
        except Exception:
            pass
    return sum(2 if unicodedata.east_asian_width(ch) in "FWA" else 1 for ch in text)


def truncate_to_limit(text: str, limit: int = 280) -> str:
    if text.endswith("\n"):
        text = text[:-1]
    if weighted_length(text) <= limit:
        return text
    lo, hi = 0, len(text)
    best = 0
    while lo <= hi:
        mid = (lo + hi) // 2
        w = weighted_length(text[:mid])
        if w <= limit:
            best = mid
            lo = mid + 1
        else:
            hi = mid - 1
    return text[:best]


if __name__ == "__main__":
    s = sys.stdin.read()
    print(truncate_to_limit(s))
