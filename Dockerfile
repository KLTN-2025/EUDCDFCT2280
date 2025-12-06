# 🟢 THAY ĐỔI: Dùng bản Full (không dùng slim) để có đủ thư viện hệ thống
FROM python:3.11

# 🟢 Cấu hình môi trường cho Aspose (.NET Core)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# Tắt chế độ check phiên bản pip để log gọn hơn
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# 🟢 Cài đặt các thư viện bổ trợ (Vẫn cần libgdiplus cho đồ họa)
RUN apt-get update && apt-get install -y \
    libgdiplus \
    libgl1 \
    libnss3 \
    libx11-6 \
    fonts-liberation \
    libicu-dev \
    lsb-release \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép và cài đặt requirements
COPY lib/backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép assets (font)
COPY assets /app/assets

# Sao chép code backend
COPY lib/backend/ .

# Lệnh chạy server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]

# # Dùng Python 3.9 (Bản này tương thích tốt nhất với Aspose và các thư viện cũ)
# FROM python:3.9-slim-bullseye

# # 🟢 QUAN TRỌNG: Cấu hình môi trường
# ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
# ENV LC_ALL=C.UTF-8
# ENV LANG=C.UTF-8
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1

# # 🟢 Cài đặt thư viện hệ thống (Full options)
# # libicu-dev: Bắt buộc cho Aspose
# # libgdiplus: Đồ họa
# # fonts-liberation: Font chữ
# RUN apt-get update && apt-get install -y \
#     wget \
#     gnupg \
#     libgdiplus \
#     libc6-dev \
#     libicu-dev \
#     libharfbuzz0b \
#     libfontconfig1 \
#     libgl1 \
#     libglib2.0-0 \
#     poppler-utils \
#     libfreetype6 \
#     fonts-liberation \
#     libkrb5-3 \
#     zlib1g \
#     libssl-dev \
#     --no-install-recommends \
#     && rm -rf /var/lib/apt/lists/*

# # Thiết lập thư mục làm việc
# WORKDIR /app

# # Copy requirements và cài đặt
# COPY lib/backend/requirements.txt .
# RUN pip install --no-cache-dir --upgrade pip && \
#     pip install --no-cache-dir -r requirements.txt

# # Copy assets (font)
# COPY assets /app/assets

# # Copy code backend
# COPY lib/backend/ .

# # Lệnh chạy server
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]