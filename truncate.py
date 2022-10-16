import sys
import unicodedata

s = "".join(sys.stdin.readlines())
for i in range(1, len(s)):
    if sum([(1, 2)[unicodedata.east_asian_width(x) in "FWA"] for x in s[:-i]]) <= 280:
        print(s[:-i])
        break
