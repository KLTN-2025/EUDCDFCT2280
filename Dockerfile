# Sử dụng ảnh Python 3.11 (hoặc 3.12, 3.13)
FROM python:3.11-slim

# Cài đặt các thư viện hệ thống
RUN apt-get update && apt-get install -y \
    libgdiplus \
    libc6-dev \
    libicu-dev \
    libharfbuzz0b \
    libfontconfig1 \
    poppler-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Thư mục làm việc bên trong Docker
WORKDIR /app

# ✅ SỬA LỖI: Sao chép requirements.txt từ thư mục con
COPY lib/backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ✅ SỬA LỖI: Sao chép thư mục assets (nay đã cùng cấp)
COPY assets ./assets

# ✅ SỬA LỖI: Sao chép code từ thư mục con
COPY lib/backend/ .

# Lệnh chạy
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]