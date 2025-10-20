FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y gcc libssl-dev \
    && apt-get install -y netcat-openbsd \
    && apt-get purge -y gcc libssl-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x db_check.sh

RUN pip3 install --no-cache-dir -r requirements.txt

ENV MYSQL_HOST=mysql_db
ENV MYSQL_PORT=3306

# CMD ["sh", "-c", "./db_check.sh ${MYSQL_HOST} ${MYSQL_PORT} && python3 run.py"]
CMD ["python3", "run.py"]
