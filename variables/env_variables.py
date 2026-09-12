import os

DEV_URL = 'http://localhost:3000/dev'
PROD_URL = 'http://localhost:3000/prod'
AUTH_TOKEN = "mysecrettoken"

BASE_URL = os.getenv("BASE_URL", PROD_URL)

