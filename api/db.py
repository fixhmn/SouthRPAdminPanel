import os
import aiomysql

_pool = None

async def get_pool():
    global _pool
    if _pool is None:
        _pool = await aiomysql.create_pool(
            host=os.getenv("DB_HOST", "127.0.0.1"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASS", ""),
            db=os.getenv("DB_NAME", "srpt_db"),
            autocommit=True,
            minsize=1,
            maxsize=10,
        )
    return _pool
