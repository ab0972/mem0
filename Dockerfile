FROM python:3.11-slim
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安裝Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# 複製專案文件
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --only main

# 複製原始碼
COPY . .

# 設置環境變數
ENV MEM0_DB_URL=${MEM0_DB_URL}
EXPOSE 8000

CMD ["poetry", "run", "uvicorn", "mem0.api:app", "--host", "0.0.0.0", "--port", "8000"]
