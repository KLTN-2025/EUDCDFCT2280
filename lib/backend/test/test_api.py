import requests

BASE_URL = "http://127.0.0.1:8000/upload"  # đổi thành IP backend nếu chạy server

# 1. Test /upload (detect font trong file)
def test_upload(file_path):
    url = f"{BASE_URL}/upload"
    files = {"file": open(file_path, "rb")}
    response = requests.post(url, files=files)
    print("=== /upload response ===")
    print(response.json())


# 2. Test /convert (chuyển đổi font + upload lên S3)
def test_convert(file_path, target_font="Arial", force_all=True):
    url = f"{BASE_URL}/convert"
    files = {"file": open(file_path, "rb")}
    data = {
        "target_font": target_font,
        "force_all": "1" if force_all else "0"
    }
    response = requests.post(url, files=files, data=data)
    print("=== /convert response ===")
    print(response.json())  # sẽ có result_url


if __name__ == "__main__":
    # test_file = "test.docx"  # đổi thành file Word/PDF bạn muốn thử

    test_file = r"E:\splash_screen\splash_screen\lib\backend\test\test.txt"


    # Test detect font
    test_upload(test_file)

    # Test convert font
    test_convert(test_file, target_font="Times New Roman")
