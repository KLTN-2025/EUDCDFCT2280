import boto3
import uuid
import os

# Tạo client S3
s3 = boto3.client("s3")

# Tên bucket bạn đã tạo trên AWS S3
bucket_name = "my-ecolive-storage"  # đổi thành bucket thật

# File local cần upload
file_path = "test.txt"

# Sinh key duy nhất để tránh ghi đè
key = f"uploads/{uuid.uuid4().hex}_{os.path.basename(file_path)}"

# Upload file
s3.upload_file(file_path, bucket_name, key)

print(f"✅ Upload thành công! File lưu trên S3: {key}")
