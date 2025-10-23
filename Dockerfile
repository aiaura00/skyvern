FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PORT=8080 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget ca-certificates gnupg \
    fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 \
    libdbus-1-3 libfontconfig1 libgcc-s1 libglib2.0-0 libgdk-pixbuf2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libstdc++6 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

RUN pip install playwright && playwright install --with-deps chromium

EXPOSE ${PORT}

CMD ["sh", "-c", "uvicorn skyvern.main:app --host 0.0.0.0 --port ${PORT} --proxy-headers"]
