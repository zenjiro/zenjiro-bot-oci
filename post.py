import os
import sys

from requests_oauthlib import OAuth1Session

screen_name = sys.argv[1].lower()
response = OAuth1Session(
    os.environ.get(f"{screen_name}_API_KEY"),
    client_secret=os.environ.get(f"{screen_name}_API_SECRET_KEY"),
    resource_owner_key=os.environ.get(f"{screen_name}_ACCESS_TOKEN"),
    resource_owner_secret=os.environ.get(f"{screen_name}_ACCESS_TOKEN_SECRET"),
).post(
    "https://api.twitter.com/2/tweets",
    json={"text": sys.stdin.read()},
)
if response.status_code != 201:
    raise Exception(
        f"Request returned an error: {response.status_code} {response.text}"
    )
print(f"Response code: {response.status_code}")
print(response.json())
