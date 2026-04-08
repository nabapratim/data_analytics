import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

required_vars = ["DB_USER", "DB_PASS", "DB_HOST", "DB_PORT", "DB_NAME"]
missing = [v for v in required_vars if not os.getenv(v)]

if missing:
    raise EnvironmentError(f"Missing environment variables: {missing}")

engine = create_engine(
    f"postgresql+psycopg2://{os.environ['DB_USER']}:{os.environ['DB_PASS']}@"
    f"{os.environ['DB_HOST']}:{os.environ['DB_PORT']}/{os.environ['DB_NAME']}",
    pool_pre_ping=True
)
