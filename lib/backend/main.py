import socket
from fastapi import FastAPI, UploadFile, File, Form, WebSocket, WebSocketDisconnect
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi import FastAPI, HTTPException, Query
from fastapi import Body
from fastapi import Request
import os, fitz, uuid
import shutil, os, uuid, json 
from typing import List, Dict, Optional
import fitz # pymupdf 
from docx import Document 
from google.cloud import firestore 
import boto3
from PIL import Image
from dotenv import load_dotenv
import requests
from docx import Document
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
import json
from google.cloud import firestore
# from docx2pdf import convert
import re
import logging
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
import boto3, uuid, os
from botocore.exceptions import ClientError
import uuid
from langdetect import detect, DetectorFactory
DetectorFactory.seed = 0  # đảm bảo kết quả ổn định
from tempfile import NamedTemporaryFile
from deep_translator import GoogleTranslator
import mimetypes
from transformers import pipeline
import tempfile, boto3, os
import tempfile, os, requests, logging, shutil, uuid
from PyPDF2 import PdfReader
import io, boto3, uuid
from docx.oxml.ns import qn
from docx.shared import Pt
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm
from reportlab.lib.pagesizes import letter
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from urllib.parse import urlparse
import aspose.words as aw
from botocore.exceptions import ClientError
from difflib import SequenceMatcher, ndiff
from pydantic import BaseModel
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Form
import asyncio
import time
from datetime import datetime, timedelta, timezone
import traceback
import cloudconvert

# Lấy API Key từ biến môi trường
CLOUDCONVERT_API_KEY = os.getenv("CLOUDCONVERT_API_KEY")

# Cập nhật hàm này trong main.py
def convert_docx_to_pdf_cloudconvert(input_path: str, output_path: str):
    api_key = os.getenv("CLOUDCONVERT_API_KEY")
    if not api_key:
        raise Exception("Chưa cấu hình CLOUDCONVERT_API_KEY")

    api = cloudconvert.Api(api_key=api_key)
    
    try:
        # 1. Tạo Job
        upload_job = api.Job.create(payload={
            "tasks": {
                "upload-my-file": {
                    "operation": "import/upload"
                },
                "convert-my-file": {
                    "operation": "convert",
                    "input": "upload-my-file",
                    "output_format": "pdf",
                    "engine": "office" 
                },
                "export-my-file": {
                    "operation": "export/url",
                    "input": "convert-my-file"
                }
            }
        })
        
        upload_task_id = upload_job['tasks'][0]['id']
        
        # 2. Upload file lên
        upload_task = api.Task.upload(file_name=input_path, task_id=upload_task_id)
        
        # 3. Chờ convert xong
        job_id = upload_job['id']
        res = api.Job.wait(id=job_id) 
        
        # 4. Tìm task export và lấy URL
        export_task = next((task for task in res['tasks'] if task['name'] == 'export-my-file' and task['status'] == 'finished'), None)
        
        if not export_task or not export_task.get('result') or not export_task['result'].get('files'):
             raise Exception("CloudConvert không trả về file kết quả!")

        file_url = export_task['result']['files'][0]['url']
        
        # 5. Tải file về máy server (QUAN TRỌNG: stream=True)
        with requests.get(file_url, stream=True) as r:
            r.raise_for_status()
            with open(output_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        
        # Kiểm tra dung lượng file tải về
        if os.path.getsize(output_path) < 100: # File quá nhỏ (<100 bytes) chắc chắn là lỗi
             raise Exception("File PDF tải về bị lỗi (dung lượng quá nhỏ)")

        return output_path

    except Exception as e:
        logger.error(f"CloudConvert Error: {e}")
        raise e

# 🟢 Cấu hình log chi tiết
logging.basicConfig(
    level=logging.DEBUG,  # Hiển thị toàn bộ log chi tiết
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

logger = logging.getLogger("ecolive-debug")

# 🔹 Xác định đường dẫn chính xác đến file JSON trong thư mục backend
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
cred_path = os.path.join(BASE_DIR, "secrets/firebase-key.json")

# 🔹 Kết nối Firestore
db = firestore.Client.from_service_account_json(cred_path)
print("✅ Firestore connected successfully.")

# --- Load .env --- 
load_dotenv()

# --- Firestore: chỉ khởi tạo duy nhất 1 lần ---
try:
    cred_path = os.path.join(BASE_DIR, "secrets/firebase-key.json")
    db = firestore.Client.from_service_account_json(cred_path)
    print("✅ Firestore connected successfully.")
    print("Firestore Project ID:", db.project)
except Exception as e:
    print("❌ Firestore init failed:", e)
    db = None

# --- Firestore giữ nguyên --- 
print("Firestore Project ID:", db.project) 

# --- AWS S3 Config --- 
S3_REGION = os.getenv("AWS_DEFAULT_REGION", "ap-southeast-2")
S3_BUCKET = os.getenv("AWS_S3_BUCKET", "my-ecolive-storage") 
s3_client = boto3.client( 
    "s3", 
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"), 
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"), 
    region_name=os.getenv("AWS_DEFAULT_REGION", "ap-southeast-2") 
)

# 🟢 Firestore client
# try:
#     firestore_client = firestore.Client()
#     logger.info("✅ Firestore connected successfully.")
#     logger.info(f"Firestore Project ID: {firestore_client.project}")
# except Exception as e:
#     logger.error(f"❌ Firestore connection failed: {e}")
#     firestore_client = None

app = FastAPI()


# TMP_DIR = tempfile.gettempdir()
# TMP_DIR = "/tmp/ecolive"
TMP_DIR = "/tmp/ecolive"
os.makedirs(TMP_DIR, exist_ok=True)
CLEANUP_OLDER_THAN_SECONDS = 60 * 30  # 30 phút

def cleanup_tmp_dir():
    """Xóa file cũ hơn ngưỡng (chạy khi tạo file mới)."""
    now = time.time()
    for fname in os.listdir(TMP_DIR):
        path = os.path.join(TMP_DIR, fname)
        try:
            if os.path.isfile(path):
                mtime = os.path.getmtime(path)
                if now - mtime > CLEANUP_OLDER_THAN_SECONDS:
                    os.remove(path)
        except Exception:
            pass

# --- Language normalization map (dễ mở rộng) ---
LANG_MAP = {
    "chinese": "zh-CN",
    "zh": "zh-CN",
    "zh-cn": "zh-CN",
    "zh_cn": "zh-CN",
    "cn": "zh-CN",
    "chinese_traditional": "zh-TW",
    "zh-tw": "zh-TW",
    "korean": "ko",
    "japanese": "ja",
    "english": "en",
    "en": "en",
    "french": "fr",
    # thêm nếu cần
}


def normalize_lang(lang: Optional[str], default: str = "en") -> str:
    if not lang:
        return default
    key = lang.strip().lower()
    return LANG_MAP.get(key, lang)


# --- Tokenize thông minh (giữ dấu câu, unicode) ---
import re
TOKEN_RE = re.compile(r"(\w+|[^\w\s]+)", flags=re.UNICODE)


def tokenize(text: str) -> List[str]:
    if not text:
        return []
    return [m.group(0) for m in TOKEN_RE.finditer(text)]

# --- Diff with context ---
def get_word_diff_with_context(old_text: str, new_text: str, context_radius: int = 3) -> List[Dict]:
    """
    Trả về danh sách dict:
    [
      {"word": "từ", "type": "added"/"removed", "pos": j, "context": "3 words around"}
    ]
    `pos` là chỉ số token trong new_text (với added) hoặc old_text (với removed).
    """
    old_tokens = tokenize(old_text)
    new_tokens = tokenize(new_text)

    matcher = SequenceMatcher(None, old_tokens, new_tokens)
    diffs = []
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag in ("replace", "insert"):
            # added tokens (from new_tokens[j1:j2])
            for idx, tok in enumerate(new_tokens[j1:j2], start=j1):
                start = max(0, idx - context_radius)
                end = min(len(new_tokens), idx + context_radius + 1)
                context = " ".join(new_tokens[start:end])
                diffs.append({"word": tok, "type": "added", "pos": idx, "context": context})
        if tag in ("replace", "delete"):
            # removed tokens (from old_tokens[i1:i2])
            for idx, tok in enumerate(old_tokens[i1:i2], start=i1):
                start = max(0, idx - context_radius)
                end = min(len(old_tokens), idx + context_radius + 1)
                context = " ".join(old_tokens[start:end])
                diffs.append({"word": tok, "type": "removed", "pos": idx, "context": context})
    return diffs


# --- Connections per user (user_id -> list[WebSocket]) ---
connections: Dict[str, List[WebSocket]] = {}


# --- Helper: send to user via WS (if any) ---
async def push_to_user(user_id: str, payload: dict):
    conns = connections.get(user_id)
    if not conns:
        return
    dead = []
    for ws in conns:
        try:
            await ws.send_text(json.dumps(payload))
        except Exception:
            dead.append(ws)
    # cleanup dead sockets
    for d in dead:
        try:
            conns.remove(d)
        except:
            pass
    if len(conns) == 0:
        connections.pop(user_id, None)

# def save_temp_file(upload_file: UploadFile) -> str:
#     ext = os.path.splitext(upload_file.filename)[1]
#     tmp_path = os.path.join(TMP_DIR, f"{uuid.uuid4().hex}{ext}")
#     with open(tmp_path, "wb") as f:
#         shutil.copyfileobj(upload_file.file, f)
#     return tmp_path
def save_temp_file(file: UploadFile) -> str:
    """
    Lưu UploadFile vào file tạm CÓ ĐUÔI FILE CHÍNH XÁC.
    Trả về ĐƯỜNG DẪN (string) đến file tạm.
    """
    try:
        # Lấy đuôi file từ tên file upload
        _name, suffix = os.path.splitext(file.filename)
        
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp_file:
            logger.info(f"Đang lưu file upload {file.filename} về {temp_file.name}...")
            content = file.file.read()
            temp_file.write(content)
            
            logger.info(f"Lưu file tạm xong: {temp_file.name}")
            return temp_file.name # ✅ Trả về STRING ĐƯỜNG DẪN
            
    except Exception as e:
        logger.error(f"Lỗi khi lưu file tạm {file.filename}: {e}")
        raise e
    finally:
        file.file.close()


# --- Font detection gi ữ nguyên ---
def detect_fonts_docx(path: str) -> List[str]:
    fonts = set()
    doc = Document(path)
    for p in doc.paragraphs:
        for r in p.runs:
            if r.font and r.font.name:
                fonts.add(r.font.name)
    return list(fonts)


def detect_fonts_pdf(path: str) -> List[str]:
    fonts = set()
    doc = fitz.open(path)
    for page in doc:
        blocks = page.get_text("dict")["blocks"]
        for b in blocks:
            for line in b.get("lines", []):
                for span in line.get("spans", []):
                    name = span.get("font")
                    if name:
                        fonts.add(name)
    return list(fonts)


@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    tmp = save_temp_file(file)
    ext = tmp.lower().rsplit(".", 1)[-1]
    try:
        if ext == "docx":
            fonts = detect_fonts_docx(tmp)
        elif ext == "pdf":
            fonts = detect_fonts_pdf(tmp)
        else:
            fonts = []
        return JSONResponse({"fonts": fonts})
    finally:
        try:
            os.remove(tmp)
        except:
            pass


# --- Conversion giữ nguyên ---
def convert_docx_to_font(path: str, target_font: str, force_all: bool):
    doc = Document(path)
    for p in doc.paragraphs:
        for r in p.runs:
            current = r.font.name
            if force_all or (current and current != target_font):
                r.font.name = target_font
    out = path + ".converted.docx"
    doc.save(out)
    return out


def convert_pdf_simple_to_pdf(path: str, target_font: str, force_all: bool):
    import fitz
    from reportlab.pdfgen import canvas
    from reportlab.lib.pagesizes import letter
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont

    ttf_map = {
        "Arial": "/app/fonts/Arial.ttf",
        "Calibri": "/app/fonts/Calibri.ttf",
        "Times New Roman": "/app/fonts/TimesNewRoman.ttf",
        "Serif": "/app/fonts/Serif.ttf",
        "Sans-serif": "/app/fonts/Sans-serif.ttf",
        "Script": "/app/fonts/Script.ttf",
    }
    ttf_path = ttf_map.get(target_font)
    if not ttf_path or not os.path.exists(ttf_path):
        raise Exception("TTF for target font not found on server.")

    out_pdf = path + ".converted.pdf"
    doc = fitz.open(path)
    c = canvas.Canvas(out_pdf, pagesize=letter)
    pdfmetrics.registerFont(TTFont("TargetFont", ttf_path))

    for p in range(len(doc)):
        page = doc.load_page(p)
        page_text = page.get_text("text")
        c.setFont("TargetFont", 12)
        textobject = c.beginText(40, 800)
        for line in page_text.splitlines():
            textobject.textLine(line)
        c.drawText(textobject)
        c.showPage()
    c.save()
    return out_pdf


# --- Thay GCS → AWS S3 ---
def upload_to_s3(local_path: str, content_type="image/png", folder="converted_image") -> str:
    key = f"{folder}/{uuid.uuid4().hex}_{os.path.basename(local_path)}"
    logger.debug(f"🔄 Bắt đầu upload file lên S3: {key}")

    try:
        s3_client.upload_file(
            local_path,
            S3_BUCKET,
            key,
            ExtraArgs={"ContentType": content_type},  # ❌ KHÔNG dùng ACL
        )
        url = f"https://{S3_BUCKET}.s3.{S3_REGION}.amazonaws.com/{key}"
        logger.info(f"✅ Upload thành công: {url}")
        return url

    except ClientError as e:
        logger.error(f"❌ Lỗi AWS S3 khi upload: {e}")
        raise HTTPException(status_code=500, detail=f"AWS S3 Upload Error: {str(e)}")

    except Exception as e:
        logger.error(f"⚠️ Lỗi không xác định khi upload_to_s3: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    
def upload_detect_file_to_s3(local_path: str, content_type="application/octet-stream") -> str:
    key = f"uploaded_files/{uuid.uuid4().hex}_{os.path.basename(local_path)}"
    logger.debug(f"📤 Upload detect-file lên S3: {key}")

    try:
        s3_client.upload_file(
            local_path,
            S3_BUCKET,
            key,
            ExtraArgs={"ContentType": content_type},
        )
        url = f"https://{S3_BUCKET}.s3.{S3_REGION}.amazonaws.com/{key}"
        logger.info(f"✅ Upload detect-file thành công: {url}")
        return url
    except ClientError as e:
        logger.error(f"❌ Lỗi AWS S3 khi upload detect-file: {e}")
        raise HTTPException(status_code=500, detail=f"AWS S3 Upload Error: {str(e)}")

    
@app.post("/upload-to-s3")
async def upload_to_s3_endpoint(file: UploadFile = File(...)):
    """
    Endpoint dùng để upload file từ Flutter lên S3.
    Không ảnh hưởng các chức năng khác.
    """
    tmp_path = None
    try:
        logger.info(f"📥 Nhận file từ Flutter: {file.filename}, content_type={file.content_type}")
        tmp_path = save_temp_file(file)
        content_type = file.content_type or "application/octet-stream"
        # s3_url = upload_to_s3(tmp_path, content_type=content_type)
        s3_url = upload_detect_file_to_s3(tmp_path, content_type=content_type)
        logger.info(f"✅ Upload thành công: {s3_url}")
        return {"url": s3_url}
    except Exception as e:
        logger.exception("❌ Lỗi upload_to_s3_endpoint")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        try:
            if tmp_path and os.path.exists(tmp_path):
                os.remove(tmp_path)
        except:
            pass

@app.post("/convert")
async def convert(file: UploadFile = File(...), target_font: str = Form(...), force_all: str = Form("0")):
    tmp = save_temp_file(file)
    try:
        ext = tmp.lower().rsplit(".", 1)[-1]
        force_flag = bool(int(force_all))
        if ext == "docx":
            out = convert_docx_to_font(tmp, target_font, force_flag)
        elif ext == "pdf":
            out = convert_pdf_simple_to_pdf(tmp, target_font, force_flag)
        else:
            return JSONResponse({"error": "Unsupported file"}, status_code=400)

        # upload to S3
        url = upload_to_s3(out)

        # log to Firestore (giữ nguyên)
        db.collection("conversion_history").add({
            "original_filename": file.filename,
            "result_url": url,
            "target_font": target_font,
            "timestamp": firestore.SERVER_TIMESTAMP
        })

        return JSONResponse({"result_url": url})
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        for p in [tmp, tmp + ".converted.docx", tmp + ".converted.pdf"]:
            try:
                if os.path.exists(p):
                    os.remove(p)
            except:
                pass


# --- Mapping giữ nguyên, chỉ đổi sang S3 ---
def convert_docx_with_mapping(path: str, font_mapping: Dict[str, str]):
    doc = Document(path)
    for p in doc.paragraphs:
        for r in p.runs:
            current = r.font.name
            if current in font_mapping:
                r.font.name = font_mapping[current]
    out = path + ".mapped.docx"
    doc.save(out)
    return out

def convert_pdf_with_mapping(path: str, font_mapping: Dict[str, str]):
    import fitz
    from reportlab.pdfgen import canvas
    from reportlab.lib.pagesizes import letter
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont

    out_pdf = path + ".mapped.pdf"
    doc = fitz.open(path)
    c = canvas.Canvas(out_pdf, pagesize=letter)

    for tgt in set(font_mapping.values()):
        ttf_path = f"/app/fonts/{tgt}.ttf"
        if os.path.exists(ttf_path):
            pdfmetrics.registerFont(TTFont(tgt, ttf_path))

    for p in range(len(doc)):
        page = doc.load_page(p)
        blocks = page.get_text("dict")["blocks"]
        textobject = c.beginText(40, 800)

        for b in blocks:
            for line in b.get("lines", []):
                for span in line.get("spans", []):
                    current_font = span.get("font")
                    text = span.get("text")
                    tgt_font = font_mapping.get(current_font, "Times New Roman")
                    textobject.setFont(tgt_font, 12)
                    textobject.textLine(text)

        c.drawText(textobject)
        c.showPage()

    c.save()
    return out_pdf

@app.post("/convert-mapping")
async def convert_mapping(file: UploadFile = File(...), mapping: str = Form(...)):
    tmp = save_temp_file(file)
    try:
        ext = tmp.lower().rsplit(".", 1)[-1]
        font_mapping = json.loads(mapping)

        if ext == "docx":
            out = convert_docx_with_mapping(tmp, font_mapping)
        elif ext == "pdf":
            out = convert_pdf_with_mapping(tmp, font_mapping)
        else:
            return JSONResponse({"error": "Unsupported file"}, status_code=400)

        url = upload_to_s3(out)

        db.collection("conversion_history").add({
            "original_filename": file.filename,
            "result_url": url,
            "mapping": font_mapping,
            "timestamp": firestore.SERVER_TIMESTAMP
        })

        return JSONResponse({"result_url": url})
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        try:
            os.remove(tmp)
        except:
            pass
        
HF_TOKEN = os.getenv("HF_TOKEN")  # để trong .env
HF_HEADERS = {"Authorization": f"Bearer {HF_TOKEN}"}

@app.post("/ocr-convert")
async def ocr_convert(file: UploadFile = File(...), output: str = Form("text")):
    tmp = save_temp_file(file)
    try:
        # OCR bằng Hugging Face
        with open(tmp, "rb") as f:
            response = requests.post(
                "https://api-inference.huggingface.co/models/microsoft/trocr-base-printed",
                headers=HF_HEADERS,
                data=f.read()
            )
        response.raise_for_status()
        result = response.json()
        text = ""
        if isinstance(result, list) and "generated_text" in result[0]:
            text = result[0]["generated_text"]

        # Nếu chỉ cần text
        if output == "text":
            return JSONResponse({"text": text})

        # Nếu cần PDF
        elif output == "pdf":
            from reportlab.pdfgen import canvas
            from reportlab.lib.pagesizes import letter

            out_pdf = tmp + ".ocr.pdf"
            c = canvas.Canvas(out_pdf, pagesize=letter)
            textobject = c.beginText(40, 800)
            for line in text.splitlines():
                textobject.textLine(line)
            c.drawText(textobject)
            c.showPage()
            c.save()

            url = upload_to_s3(out_pdf)
            return JSONResponse({"result_url": url})

        # Nếu cần DOCX
        elif output == "docx":
            out_docx = tmp + ".ocr.docx"
            doc = Document()
            doc.add_paragraph(text)
            doc.save(out_docx)

            url = upload_to_s3(out_docx)
            return JSONResponse({"result_url": url})

        else:
            return JSONResponse({"error": "Invalid output type"}, status_code=400)

    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        try:
            os.remove(tmp)
        except:
            pass

UPLOAD_DIR = "uploads"
OUTPUT_DIR = "outputs"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

# # 🟢 Đăng ký nhiều font sẵn có trong thư mục assets/fonts
# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# FONT_DIR = os.path.join(BASE_DIR, "../../assets/fonts")

# CUSTOM_FONTS = {
#     "Arial": os.path.join(FONT_DIR, "Arial.ttf"),
#     "Calibri": os.path.join(FONT_DIR, "Calibri.ttf"),
#     "SansSerif": os.path.join(FONT_DIR, "Sans-serif.ttf"),
#     "Serif": os.path.join(FONT_DIR, "Serif.ttf"),
#     "Script": os.path.join(FONT_DIR, "Script.ttf"),
# }

# for name, path in CUSTOM_FONTS.items():
#     if os.path.exists(path):
#         pdfmetrics.registerFont(TTFont(name, path))
#         print(f"✅ Font registered: {name}")
#     else:
#         print(f"⚠️ Missing font file: {path}")

# print("📂 FONT_DIR thực tế:", FONT_DIR)
# print("📂 Danh sách trong assets/fonts:", os.listdir(FONT_DIR) if os.path.exists(FONT_DIR) else "Không tồn tại!")

# # 🟢 Đăng ký nhiều font sẵn có trong thư mục assets/fonts
# BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# # ✅ SỬA LỖI: Bỏ "../../" vì 'assets' giờ đã nằm cùng cấp (bên trong /app)
# FONT_DIR = os.path.join(BASE_DIR, "assets/fonts") 

# CUSTOM_FONTS = {
#     "Arial": os.path.join(FONT_DIR, "Arial.ttf"),
#     "Calibri": os.path.join(FONT_DIR, "Calibri.ttf"),
#     "SansSerif": os.path.join(FONT_DIR, "Sans-serif.ttf"),
#     "Serif": os.path.join(FONT_DIR, "Serif.ttf"),
#     "Script": os.path.join(FONT_DIR, "Script.ttf"),
# }
 
# # Đoạn code này bây giờ sẽ chạy đúng
# for name, path in CUSTOM_FONTS.items():
#     if os.path.exists(path):
#         pdfmetrics.registerFont(TTFont(name, path))
#         print(f"✅ Font registered: {name}")
#     else:
#         print(f"⚠️ Missing font file: {path}")

# print("📂 FONT_DIR thực tế:", FONT_DIR)
# print("📂 Danh sách trong assets/fonts:", os.listdir(FONT_DIR) if os.path.exists(FONT_DIR) else "Không tồn tại!")

# 🟢 Đăng ký font một cách "thông minh"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# --- BẮT ĐẦU SỬA LỖI ---
# Thử đường dẫn MỚI (Docker) trước
docker_path = os.path.join(BASE_DIR, "assets/fonts")
# Thử đường dẫn CŨ (Python Service)
python_service_path = os.path.join(BASE_DIR, "../../assets/fonts")

FONT_DIR = None
if os.path.exists(docker_path):
    # Nếu đang chạy trong Docker, dùng đường dẫn này
    FONT_DIR = docker_path
    print(f"✅ Đã tìm thấy FONT_DIR (Môi trường Docker): {FONT_DIR}")
elif os.path.exists(python_service_path):
    # Nếu đang chạy trong Service Python cũ, dùng đường dẫn này
    FONT_DIR = python_service_path
    print(f"✅ Đã tìm thấy FONT_DIR (Môi trường Python cũ): {FONT_DIR}")
else:
    # Nếu không tìm thấy cả hai, báo lỗi
    FONT_DIR = docker_path # (Dùng tạm 1 cái để báo lỗi bên dưới)
    print(f"⚠️ LỖI: Không tìm thấy thư mục 'assets/fonts' ở cả hai đường dẫn!")
# --- KẾT THÚC SỬA LỖI ---


CUSTOM_FONTS = {
    "Arial": os.path.join(FONT_DIR, "Arial.ttf"),
    "Calibri": os.path.join(FONT_DIR, "Calibri.ttf"),
    "SansSerif": os.path.join(FONT_DIR, "Sans-serif.ttf"),
    "Serif": os.path.join(FONT_DIR, "Serif.ttf"),
    "Script": os.path.join(FONT_DIR, "Script.ttf"),
}

# Đoạn code này bây giờ sẽ chạy đúng cho cả hai môi trường
for name, path in CUSTOM_FONTS.items():
    if os.path.exists(path):
        pdfmetrics.registerFont(TTFont(name, path))
        print(f"✅ Font registered: {name}")
    else:
        print(f"⚠️ Missing font file: {path}")

print("📂 FONT_DIR thực tế:", FONT_DIR)
print("📂 Danh sách trong assets/fonts:", os.listdir(FONT_DIR) if os.path.exists(FONT_DIR) else "Không tồn tại!")

DEFAULT_FONT = "Arial"

def ensure_font_available(font_name: str) -> str:
    """
    Kiểm tra font có tồn tại không, nếu có trả về đường dẫn,
    nếu không có thì fallback sang font mặc định hoặc UnicodeCIDFont.
    """
    font_path = CUSTOM_FONTS.get(font_name)
    if font_path and os.path.exists(font_path):
        pdfmetrics.registerFont(TTFont(font_name, font_path))
        return font_path
    else:
        print(f"⚠️ Font '{font_name}' không tồn tại, dùng fallback HeiseiMin-W3")
        pdfmetrics.registerFont(UnicodeCIDFont("HeiseiMin-W3"))
        return "HeiseiMin-W3"
    
class ImageItem(BaseModel):
    url: str
    image_type: str  # Loại ảnh riêng cho item này (PNG, JPG...)

# Model nhận dữ liệu lưu lịch sử thủ công
class SelectedImagesRequest(BaseModel):
    user_id: str
    original_filename: str
    # image_urls: List[str]
    items: List[ImageItem]
    # image_type: str

@app.post("/convert-to-image")
async def convert_to_image(file: UploadFile = File(...), image_type: str = Form("PNG"), user_id: str = Form("anonymous_user"),
    user_email: str = Form(None), save_history: str = Form("true")):
    try:
        file_ext = file.filename.split(".")[-1].lower()
        temp_path = os.path.join(UPLOAD_DIR, f"{uuid.uuid4()}.{file_ext}")
        with open(temp_path, "wb") as f:
            f.write(await file.read())

        output_files = []
        s3_urls = []

        # 🟢 PDF → chuyển từng trang thành ảnh
        if file_ext == "pdf":
            # doc = fitz.open(temp_path)
            try:
                doc = fitz.open(temp_path)
            except Exception as e:
                print("⚠️ Không thể mở PDF:", e)
                return JSONResponse({"error": "File PDF bị hỏng hoặc không hợp lệ"}, status_code=400)

            for i, page in enumerate(doc):
                pix = page.get_pixmap(matrix=fitz.Matrix(2, 2))  # tăng độ nét
                img_name = f"{uuid.uuid4()}.{image_type.lower()}"
                img_path = os.path.join(OUTPUT_DIR, img_name)
                pix.save(img_path)
                output_files.append(img_path)
            doc.close()

        # 🟢 DOCX → chuyển text sang PDF trước rồi render PDF thành ảnh (KHÔNG dùng docx2pdf)
        elif file_ext == "docx":
            # 1️⃣ Chuyển DOCX → PDF tạm bằng reportlab
            pdf_temp = os.path.join(OUTPUT_DIR, f"{uuid.uuid4()}.pdf")
            from reportlab.pdfgen import canvas
            from reportlab.lib.pagesizes import letter
            from reportlab.pdfbase import pdfmetrics
            from reportlab.pdfbase.ttfonts import TTFont
            from reportlab.pdfbase.cidfonts import UnicodeCIDFont

            doc = Document(temp_path)
            pdf = canvas.Canvas(pdf_temp, pagesize=letter)

        
            # 🟢 Đảm bảo font người dùng hoặc trong file luôn khả dụng
            font_path = ensure_font_available(DEFAULT_FONT)  # hoặc thay DEFAULT_FONT bằng target_font nếu có form gửi lên

            try:
                pdf.setFont(DEFAULT_FONT, 12)
            except:
                # 🔸 Fallback Unicode nếu font lỗi (phòng trường hợp tiếng Việt, Nhật, Hàn,...)
                pdfmetrics.registerFont(UnicodeCIDFont('HeiseiMin-W3'))
                pdf.setFont("HeiseiMin-W3", 12)

            width, height = letter
            y = height - 50

            for para in doc.paragraphs:
                text = para.text.strip()
                if text:
                    pdf.drawString(50, y, text)
                    y -= 15
                    if y < 50:  # hết trang thì tạo trang mới
                        pdf.showPage()
                        try:
                            pdf.setFont(DEFAULT_FONT, 12)
                        except:
                            pdf.setFont("HeiseiMin-W3", 12)
                        y = height - 50

            pdf.save()

            # 2️⃣ Chuyển PDF vừa tạo thành ảnh
            doc_pdf = fitz.open(pdf_temp)
            for i, page in enumerate(doc_pdf):
                pix = page.get_pixmap(matrix=fitz.Matrix(3, 3))  # DPI cao = ảnh rõ nét hơn
                img_name = f"{uuid.uuid4()}.{image_type.lower()}"
                img_path = os.path.join(OUTPUT_DIR, img_name)
                pix.save(img_path)
                output_files.append(img_path)
            doc_pdf.close()

            os.remove(pdf_temp)

        else:
            return JSONResponse({"error": "Chỉ hỗ trợ file .pdf và .docx"}, status_code=400)

        # 🟣 Upload tất cả ảnh lên S3
        for path in output_files:
            url = upload_to_s3(path)
            s3_urls.append(url)

        # 🟢 Nếu không gửi user_id thì fallback
        if not user_id or user_id.strip() == "":
            user_id = "anonymous_user"

        print(f"📩 Nhận user_id từ Flutter: {user_id}")

        should_save = save_history.lower() == "true"

        if should_save:
            # Lưu theo cấu trúc users/{user_id}/image_conversion_history
            db.collection("users").document(user_id).collection("image_conversion_history").add({
                "original_filename": file.filename,
                "image_urls": s3_urls,
                "timestamp": firestore.SERVER_TIMESTAMP,
                "image_type": image_type
            })
            print(f"✅ Đã lưu lịch sử tự động cho user {user_id}")
        else:
            print(f"ℹ️ Chế độ Từng phần: Chưa lưu lịch sử, trả về {len(s3_urls)} ảnh để user chọn.")

        return JSONResponse({
            "status": "success",
            "image_urls": s3_urls,
            "user_id": user_id,  # 🟢 gợi ý thêm, để dễ debug từ Flutter
            "saved_automatically": should_save
        })

    except Exception as e:
        import traceback
        print("🔥 Lỗi /convert-to-image:", traceback.format_exc())
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        try:
            os.remove(temp_path)
            for path in output_files:
                if os.path.exists(path):
                    os.remove(path)
        except:
            pass

@app.post("/save-selected-images")
async def save_selected_images(payload: SelectedImagesRequest):
    """
    Nhận danh sách (URL + Loại ảnh), convert từng ảnh theo yêu cầu,
    upload lại S3 và lưu vào lịch sử.
    """
    try:
        if not payload.items:
            return JSONResponse({"status": "warning", "message": "Danh sách ảnh rỗng"}, status_code=400)

        final_urls = []
        
        print(f"🔄 Đang xử lý {len(payload.items)} ảnh với định dạng riêng biệt...")

        for item in payload.items:
            url = item.url
            # Chuẩn hóa đuôi file đích
            # target_ext = item.image_type.lower().replace("jpeg", "jpg")
            target_ext = item.image_type.lower()
            
            try:
                # Lấy đuôi file hiện tại của link
                current_ext = url.split('?')[0].split('.')[-1].lower()
                
                # Kiểm tra xem có cần convert không (ví dụ đang là png mà muốn lưu jpg)
                # needs_conversion = target_ext != current_ext
                # if target_ext in ["jpg", "jpeg"] and current_ext in ["jpg", "jpeg"]:
                #     needs_conversion = False
                needs_conversion = target_ext != current_ext
                
                if not needs_conversion:
                    final_urls.append(url)
                else:
                    # --- Convert Logic ---
                    # 1. Tải ảnh về RAM
                    resp = requests.get(url)
                    img = Image.open(io.BytesIO(resp.content))
                    
                    # 2. Xử lý kênh màu (PNG->JPG bị lỗi nếu có Alpha)
                    if target_ext in ["jpg", "jpeg"] and img.mode == "RGBA":
                        img = img.convert("RGB")
                    
                    # 3. Lưu vào buffer
                    img_byte_arr = io.BytesIO()
                    save_format = "JPEG" if target_ext in ["jpg", "jpeg"] else target_ext.upper()
                    img.save(img_byte_arr, format=save_format)
                    img_byte_arr.seek(0)
                    
                    # 4. Upload lên S3
                    # ⚠️ QUAN TRỌNG: Lưu vào 'converted_image' để ăn theo quyền Public của Bucket
                    new_filename = f"converted_image/{uuid.uuid4().hex}.{target_ext}"
                    
                    s3_client.upload_fileobj(
                        img_byte_arr, 
                        S3_BUCKET, 
                        new_filename,
                        ExtraArgs={"ContentType": f"image/{target_ext}"}
                    )
                    new_url = f"https://{S3_BUCKET}.s3.{S3_REGION}.amazonaws.com/{new_filename}"
                    final_urls.append(new_url)

            except Exception as sub_e:
                print(f"⚠️ Lỗi xử lý ảnh {url}: {sub_e}")
                final_urls.append(url) # Fallback: Giữ link gốc nếu lỗi

        # Lưu vào Firestore
        db.collection("users").document(payload.user_id).collection("image_conversion_history").add({
            "original_filename": payload.original_filename,
            "image_urls": final_urls,
            "timestamp": firestore.SERVER_TIMESTAMP,
            "image_type": "Mixed" # Ghi chú là hỗn hợp vì mỗi ảnh 1 kiểu
        })
        
        return {"status": "success", "message": "Đã lưu lịch sử thành công", "final_count": len(final_urls)}

    except Exception as e:
        import traceback
        print("🔥 Lỗi save-selected-images:", traceback.format_exc())
        return JSONResponse({"error": str(e)}, status_code=500)

GOOGLE_FONTS_API = "https://fonts.googleapis.com/css2?family={font_name}&display=swap"
FONT_CACHE_DIR = "assets/fonts"
os.makedirs(FONT_CACHE_DIR, exist_ok=True)

DEFAULT_FALLBACK_FONT = "Arial"

def sanitize_font_name(name: str) -> str:
    """Làm sạch tên font (ví dụ 'Times New Roman' → 'Times+New+Roman')"""
    if not name:
        return ""
    name = re.sub(r"[^a-zA-Z0-9\s+]", "", name).strip()
    return name.replace(" ", "+")

def download_font_from_google(font_name: str) -> str | None:
    """Thử tải font từ Google Fonts"""
    try:
        encoded = sanitize_font_name(font_name)
        css_url = GOOGLE_FONTS_API.format(font_name=encoded)
        css = requests.get(css_url, timeout=10).text

        # Trích URL font (.ttf hoặc .woff2)
        match = re.search(r"https://fonts\.gstatic\.com/[^)]+", css)
        if not match:
            return None
        font_url = match.group(0)
        font_ext = ".ttf" if font_url.endswith(".ttf") else ".woff2"
        font_path = os.path.join(FONT_CACHE_DIR, f"{font_name}{font_ext}")

        # Nếu font chưa tồn tại thì tải mới
        if not os.path.exists(font_path):
            r = requests.get(font_url, timeout=10)
            with open(font_path, "wb") as f:
                f.write(r.content)
            print(f"✅ Đã tải font '{font_name}' từ Google Fonts.")

        # Đăng ký font
        try:
            pdfmetrics.registerFont(TTFont(font_name, font_path))
            print(f"✅ Font '{font_name}' đã được đăng ký.")
            return font_path
        except Exception as e:
            print(f"⚠️ Lỗi đăng ký font '{font_name}': {e}")
            return None
    except Exception as e:
        print(f"⚠️ Không thể tải font '{font_name}': {e}")
        return None


def ensure_font_available(font_name: str) -> str:
    """
    Đảm bảo font tồn tại:
    - Nếu có sẵn trong CUSTOM_FONTS → dùng.
    - Nếu chưa có → tải từ Google Fonts.
    - Nếu vẫn lỗi → fallback sang Arial hoặc HeiseiMin-W3.
    """
    if font_name in CUSTOM_FONTS:
        return CUSTOM_FONTS[font_name]

    font_path = os.path.join(FONT_CACHE_DIR, f"{font_name}.ttf")
    if os.path.exists(font_path):
        try:
            pdfmetrics.registerFont(TTFont(font_name, font_path))
            return font_path
        except:
            pass

    # Thử tải từ Google Fonts
    downloaded = download_font_from_google(font_name)
    if downloaded:
        return downloaded

    # Fallback nếu không có
    try:
        pdfmetrics.registerFont(UnicodeCIDFont('HeiseiMin-W3'))
        print(f"⚠️ Font '{font_name}' không tồn tại — fallback sang HeiseiMin-W3 (Unicode).")
        return "HeiseiMin-W3"
    except:
        return DEFAULT_FALLBACK_FONT
    
s3 = boto3.client('s3')
BUCKET_NAME = "my-ecolive-storage"

# --- HUGGINGFACE TRANSLATOR ---
def get_translator(src_lang="en", tgt_lang="vi"):
    model_name = f"Helsinki-NLP/opus-mt-{src_lang}-{tgt_lang}"
    return pipeline("translation", model=model_name)

@app.post("/translate-doc")
async def translate_doc(
    file: UploadFile = File(...),
    target_lang: str = Form(...),
    user_id: str = Form(...)  # 👈 bắt buộc phải có user_id
):
    try:
        import io, uuid, os
        from PyPDF2 import PdfReader
        from docx import Document
        from deep_translator import GoogleTranslator
        from PIL import Image, ImageDraw
        from pdf2image import convert_from_path

        ext = file.filename.split('.')[-1].lower()
        content = file.file.read()

        # --- Chuẩn hóa mã ngôn ngữ ---
        lang_map = {
            "chinese": "zh-CN",
            "zh": "zh-CN",
            "zh-cn": "zh-CN",
            "zh_cn": "zh-CN",
            "cn": "zh-CN",
            "zh-tw": "zh-TW",
            "chinese_traditional": "zh-TW"
        }
        target_lang = lang_map.get(target_lang.lower(), target_lang)
        print(f"🎯 Target language sau khi chuẩn hóa: {target_lang}")

        # --- Đọc nội dung file ---
        text = ""
        if ext == "pdf":
            reader = PdfReader(io.BytesIO(content))
            text = "\n".join([page.extract_text() or "" for page in reader.pages])
        elif ext == "docx":
            doc = Document(io.BytesIO(content))
            text = "\n".join([p.text for p in doc.paragraphs])
        elif ext == "txt":
            text = content.decode("utf-8", errors="ignore")
        else:
            return {"error": "Unsupported file format"}

        if not text.strip():
            return {"error": "File không có nội dung để dịch."}

        # --- Dịch nội dung theo từng đoạn (tránh vượt giới hạn Google) ---
        translator = GoogleTranslator(source='auto', target=target_lang)
        chunks = [text[i:i+4000] for i in range(0, len(text), 4000)]
        translated_text = ""
        for i, chunk in enumerate(chunks):
            try:
                translated_chunk = translator.translate(chunk)
                translated_text += translated_chunk + "\n"
            except Exception as e:
                print(f"⚠️ Dịch lỗi đoạn {i}: {e}")
                translated_text += chunk + "\n"

        # --- Lưu file kết quả ---
        new_doc = Document()
        for line in translated_text.split("\n"):
            new_doc.add_paragraph(line.strip())
        output_path = f"/tmp/{uuid.uuid4()}.docx"
        new_doc.save(output_path)

        # --- Upload lên S3 ---
        s3_key = f"converted_language/{uuid.uuid4()}.docx"
        s3.upload_file(output_path, BUCKET_NAME, s3_key)
        result_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{s3_key}"

        # =======================================================
        # ✅ TẠO THUMBNAIL (ảnh preview)
        # =======================================================
        thumbnail_url = None
        try:
            # Nếu file đầu vào là PDF → render trang đầu làm thumbnail
            if ext == "pdf":
                temp_pdf_path = f"/tmp/{uuid.uuid4()}.pdf"
                with open(temp_pdf_path, "wb") as f:
                    f.write(content)
                pages = convert_from_path(temp_pdf_path, dpi=100, first_page=1, last_page=1)
                thumb_path = temp_pdf_path.replace(".pdf", "_thumb.jpg")
                pages[0].save(thumb_path, "JPEG")
                # Upload thumbnail lên S3
                thumb_key = f"thumbnails/{uuid.uuid4()}.jpg"
                s3.upload_file(thumb_path, BUCKET_NAME, thumb_key)
                thumbnail_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{thumb_key}"

            # Nếu file đầu vào là DOCX hoặc TXT → tạo ảnh text preview
            else:
                thumb_path = f"/tmp/{uuid.uuid4()}.jpg"
                img = Image.new('RGB', (600, 400), color=(245, 245, 245))
                d = ImageDraw.Draw(img)
                preview_text = translated_text[:200] + "..." if len(translated_text) > 200 else translated_text
                d.text((20, 20), preview_text, fill=(0, 0, 0))
                img.save(thumb_path)
                thumb_key = f"thumbnails/{uuid.uuid4()}.jpg"
                s3.upload_file(thumb_path, BUCKET_NAME, thumb_key)
                thumbnail_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{thumb_key}"

            print(f"✅ Thumbnail URL: {thumbnail_url}")
        except Exception as thumb_err:
            print(f"⚠️ Không thể tạo thumbnail: {thumb_err}")
            import traceback; traceback.print_exc()
        # =======================================================
        
        # --- Lưu lịch sử vào Firestore ---
        try:
            # from google.cloud import firestore
            from langdetect import detect
            # db = firestore.Client()
            global db
            if db is None:
                raise Exception("Firestore chưa được khởi tạo!")

            # 🔍 Phát hiện ngôn ngữ tự động
            try:
                detected_lang = detect(text)
            except:
                detected_lang = "unknown"

            user_id = user_id.strip()
            user_ref = db.collection("users").document(user_id)
            history_ref = user_ref.collection("translate_history")

            history_ref.add({
                "original_filename": file.filename,
                "source_lang": detected_lang,
                "target_lang": target_lang,
                "result_url": result_url,
                "thumbnail_url": thumbnail_url,  # ✅ Thêm vào đây
                "timestamp": firestore.SERVER_TIMESTAMP,
            })
        except Exception as log_err:
            print(f"⚠️ Không thể lưu lịch sử dịch: {log_err}")


        # --- Trả về ---
        return {
            "status": "success",
            "original_preview": text[:1000],
            "translated_preview": translated_text[:1000],
            "result_url": result_url,
            "thumbnail_url": thumbnail_url  # ✅ Trả về luôn
        }

    except Exception as e:
        import traceback
        print("❌ Error in /translate-doc:", traceback.format_exc())
        return {"error": str(e)}
    
# def fix_mojibake(text):
#     if not text: return ""
#     # Danh sách các bảng mã thường gây lỗi
#     encodings = ['cp1252', 'latin1', 'iso-8859-1']
    
#     for enc in encodings:
#         try:
#             # Thử encode về bytes theo bảng mã sai, rồi decode lại bằng utf-8
#             return text.encode(enc).decode('utf-8')
#         except Exception:
#             continue
            
#     # Nếu không sửa được thì trả về nguyên gốc
#     return text
def fix_mojibake(text):
    if not text: return ""
    
    # Cách 1: Ưu tiên dùng thư viện ftfy (nếu có) - Chuẩn công nghiệp
    try:
        import ftfy
        return ftfy.fix_text(text)
    except ImportError:
        pass

    # Cách 2: Logic thủ công "Chia để trị" (Xử lý chuỗi hỗn hợp)
    
    # Hàm sửa lỗi cho từng mảnh nhỏ
    def fix_chunk(chunk):
        # Các bảng mã thường gây lỗi Mojibake phổ biến
        encodings = ['cp1252', 'latin1', 'iso-8859-1']
        for enc in encodings:
            try:
                # Logic: Encode về bytes sai -> Decode lại bằng utf-8 chuẩn
                return chunk.encode(enc).decode('utf-8')
            except Exception:
                continue
        return chunk

    # Tách chuỗi: Tìm các ký tự KHÔNG phải Latin (Unicode > 255, ví dụ tiếng Hàn, Nhật...)
    # Regex này sẽ tách chuỗi thành: [Phần Latin lỗi, Phần Hàn xịn, Phần Latin lỗi...]
    parts = re.split(r'([^\x00-\xff]+)', text)
    
    fixed_parts = []
    for part in parts:
        # Nếu part rỗng thì bỏ qua
        if not part: 
            continue
            
        # Kiểm tra xem part này có chứa ký tự Unicode cao không
        has_high_chars = any(ord(c) > 255 for c in part)
        
        if has_high_chars:
            # Đây là tiếng Hàn/Nhật/Emoji... -> Giữ nguyên, không sửa
            fixed_parts.append(part)
        else:
            # Đây là tiếng Việt bị lỗi hoặc tiếng Anh -> Thử sửa
            fixed_parts.append(fix_chunk(part))
            
    return "".join(fixed_parts)

# --- Endpoint: /translate-doc-chunks (giữ nguyên, trả chunks list) ---
@app.post("/translate-doc-chunks")
async def translate_doc_chunks(
    file: UploadFile = File(...),
    target_lang: str = Form(...),
    user_id: str = Form(...),
):
    try:
        # 1. Xác định loại file
        filename = file.filename
        ext = filename.split('.')[-1].lower() if '.' in filename else ""
        content_bytes = await file.read() # Đọc binary
        
        text_content = ""

        # 2. Xử lý tùy theo loại file
        if ext == "docx":
            # Dùng thư viện docx để đọc
            import io
            from docx import Document
            try:
                doc = Document(io.BytesIO(content_bytes))
                # Nối các đoạn văn lại, mỗi đoạn xuống dòng
                text_content = "\n".join([para.text for para in doc.paragraphs])
            except Exception as e:
                return JSONResponse(status_code=400, content={"status": "error", "error": f"Lỗi đọc file DOCX: {str(e)}"})
                
        elif ext == "pdf":
            # Dùng thư viện PyPDF2 hoặc fitz để đọc
            import io
            from PyPDF2 import PdfReader
            try:
                reader = PdfReader(io.BytesIO(content_bytes))
                text_content = "\n".join([page.extract_text() or "" for page in reader.pages])
            except Exception as e:
                return JSONResponse(status_code=400, content={"status": "error", "error": f"Lỗi đọc file PDF: {str(e)}"})
                
        elif ext == "txt":
            # File text thì mới decode utf-8
            text_content = content_bytes.decode("utf-8", errors="ignore")
            
        else:
            return JSONResponse(status_code=400, content={"status": "error", "error": "Định dạng file không hỗ trợ. Chỉ chấp nhận .docx, .pdf, .txt"})

        # 3. Kiểm tra nội dung rỗng
        if not text_content.strip():
             return JSONResponse(status_code=400, content={"status": "error", "error": "File không có nội dung text (có thể là file scan ảnh)."})

        # 4. Chuẩn hóa ngôn ngữ đích
        target_lang_norm = normalize_lang(target_lang)

        # 5. Cắt đoạn (Split paragraphs)
        # Tách theo xuống dòng và loại bỏ dòng trống
        paragraphs = [p.strip() for p in text_content.split("\n") if p.strip()]
        translated_list = []
        # Chuẩn hóa ngôn ngữ
        target_lang_norm = normalize_lang(target_lang)
        translator = GoogleTranslator(source="auto", target=target_lang_norm)

        # 6. Dịch từng đoạn
        for para in paragraphs:
            try:
                translated = translator.translate(para)
                translated = fix_mojibake(translated)
            except Exception:
                translated = para  # Fallback nếu lỗi dịch
            
            # Tạo diff (để UI tô màu)
            diff = get_word_diff_with_context("", translated)
            
            translated_list.append({
                "original": para, 
                "translated": translated, 
                "diff": diff
            })

        return {"status": "success", "chunks": translated_list}

    except Exception as e:
        import traceback
        print(traceback.format_exc())
        return JSONResponse(status_code=500, content={"status": "error", "error": str(e)})
    
# --- Hàm tạo diff giữa bản gốc và bản dịch ---
def get_diff(original: str, translated: str) -> List[Dict]:
    """
    Trả về danh sách từ khác biệt:
    [{"word": "từ", "type": "added/removed"}]
    """
    diff_list = []
    s = SequenceMatcher(None, original.split(), translated.split())
    for tag, i1, i2, j1, j2 in s.get_opcodes():
        if tag in ("replace", "insert"):
            for w in translated.split()[j1:j2]:
                diff_list.append({"word": w, "type": "added"})
        if tag in ("replace", "delete"):
            for w in original.split()[i1:i2]:
                diff_list.append({"word": w, "type": "removed"})
    return diff_list

connections = {}

# --- WebSocket endpoint: realtime edits ---
@app.websocket("/ws-segment")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    """
    Client kết nối: ws://.../ws-segment?user_id=USER123
    Message client nên gửi JSON:
      { "type":"edit_update", "index": 0, "text":"...", "previous_translation":"...", "target_lang":"korean" }
    Server trả JSON:
      { "type":"diff_update", "index":0, "translated":"...", "diff":[{word,type,pos,context}, ...] }
    """
    await websocket.accept()
    # register
    if user_id not in connections:
        connections[user_id] = []
    connections[user_id].append(websocket)

    try:
        while True:
            msg = await websocket.receive_text()
            try:
                data = json.loads(msg)
            except Exception:
                # ignore invalid JSON
                continue

            typ = data.get("type", "edit_update")
            index = data.get("index", -1)
            text = data.get("text", "")
            prev = data.get("previous_translation", "") or ""
            target_lang = normalize_lang(data.get("target_lang"), default="en")
            user_id_clean = user_id.strip()

            # dịch realtime (fallback giữ nguyên text nếu lỗi)
            try:
                translated_text = GoogleTranslator(source="auto", target=target_lang).translate(text)
            except Exception:
                translated_text = text

            # diff với prev
            diff = get_word_diff_with_context(prev, translated_text)

            # Trả về cho client hiện tại (không broadcast cho tất cả để tránh xung đột)
            await websocket.send_text(json.dumps({
                "type": "diff_update",
                "index": index,
                "translated": translated_text,
                "diff": diff
            }))

    except WebSocketDisconnect:
        # remove websocket
        try:
            connections[user_id].remove(websocket)
            if len(connections[user_id]) == 0:
                connections.pop(user_id, None)
        except Exception:
            pass
    except Exception:
        # đảm bảo cleanup nếu lỗi
        try:
            connections[user_id].remove(websocket)
        except:
            pass
        
# --- API dịch lại 1 đoạn ---
def replace_paragraph_text_keep_style(paragraph, new_text):
    if not paragraph.runs:
        paragraph.add_run(new_text)
        return
    # Gán text mới vào Run đầu tiên để giữ Font/Size/Color
    paragraph.runs[0].text = new_text
    # Xóa các Run còn lại để tránh thừa chữ cũ
    for run in paragraph.runs[1:]:
        run.text = ""

# --- Export DOCX (nâng cao: cleanup + FileResponse bytes) ---
@app.post("/export-docx")
async def export_docx(
    file: UploadFile = File(None),
    user_id: str = Form(...),
    target_lang: Optional[str] = Form(None),
    segments: str = Form(...),
):
    try:
        segments_list = json.loads(segments)
        cleanup_tmp_dir()
        
        out_filename = f"translated_{uuid.uuid4().hex[:8]}.docx"
        out_path = os.path.join(TMP_DIR, out_filename)

        # Biến cờ để xác định có dùng template không
        used_template = False
        original_tmp = None

        # 1. Kiểm tra nếu file gửi lên là DOCX hợp lệ
        if file:
            ext = file.filename.split('.')[-1].lower()
            if ext == 'docx':
                original_tmp = save_temp_file(file)
                try:
                    # Thử mở file để chắc chắn nó không hỏng
                    doc = Document(original_tmp)
                    
                    # Logic thay thế text giữ format
                    for i, para in enumerate(doc.paragraphs):
                        if i < len(segments_list):
                            new_text = segments_list[i]
                            if isinstance(new_text, dict): 
                                new_text = new_text.get("translated", "")
                            new_text = str(new_text).strip()
                            
                            if new_text:
                                if not para.runs: 
                                    para.add_run(new_text)
                                else:
                                    para.runs[0].text = new_text
                                    for run in para.runs[1:]: 
                                        run.text = ""
                    
                    doc.save(out_path)
                    used_template = True
                except Exception as e:
                    logger.warning(f"⚠️ Lỗi khi dùng file gốc làm template: {e}. Sẽ tạo file mới.")
                    used_template = False

        # 2. Nếu không dùng template (do file không phải docx, hoặc bị lỗi), tạo file mới
        if not used_template:
            doc = Document()
            for seg in segments_list:
                text = seg if isinstance(seg, str) else seg.get("translated", "")
                doc.add_paragraph(str(text))
                doc.add_paragraph("") # Dòng trống ngăn cách
            doc.save(out_path)

        # 3. Upload S3
        s3_url = upload_to_s3(
            out_path, 
            content_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            folder="exported_documents"
        )

        # 4. Lưu lịch sử
        try:
            # Cleanup file tạm của template
            if original_tmp and os.path.exists(original_tmp):
                os.remove(original_tmp)

            user_id_clean = (user_id or "anonymous_user").strip()
            db.collection("users").document(user_id_clean).collection("translate_history").add({
                "original_filename": file.filename if file else "edited_document.docx",
                "result_url": s3_url,
                "target_lang": target_lang,
                "source_lang": "auto",
                "type": "export_edited",
                "thumbnail_url": None,
                "timestamp": firestore.SERVER_TIMESTAMP
            })
        except Exception as e:
            logger.warning(f"Lỗi lưu lịch sử: {e}")

        # 5. Trả file về
        return FileResponse(
            out_path,
            media_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            filename=f"translated_final.docx"
        )

    except Exception as e:
        logger.error(traceback.format_exc())
        return JSONResponse(status_code=500, content={"status": "error", "message": str(e)})
    
# Hàm tính highlight từ khác biệt
def get_diff_words(old_text: str, new_text: str) -> List[str]:
    old_words = old_text.split()
    new_words = new_text.split()
    diff_words = []

    matcher = SequenceMatcher(None, old_words, new_words)
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag in ("replace", "insert"):
            diff_words.extend(new_words[j1:j2])
    return diff_words

# --- REST: retranslate-segment (nâng cao) ---
@app.post("/retranslate-segment")
async def retranslate_segment(
    text: str = Form(...),
    target_lang: Optional[str] = Form(None),
    user_id: Optional[str] = Form(None),
    previous_translation: Optional[str] = Form(None),
):
    """
    previous_translation là tùy chọn (nếu UI gửi thì backend so sánh để trả diff).
    Trả về:
    {
      "status":"success",
      "translated":"....",
      "diff": [ {word,type,pos,context}, ... ],
      "preview":"..."
    }
    """
    try:
        # default target_lang nếu không truyền
        target_lang_norm = normalize_lang(target_lang, default="en")

        user_id_clean = (user_id or "anonymous_user").strip()

        # Dịch (GoogleTranslator)
        try:
            translated_text = GoogleTranslator(source="auto", target=target_lang_norm).translate(text)
            translated_text = fix_mojibake(translated_text)
        except Exception:
            translated_text = text  # fallback

        # Tính diff (so với previous_translation hoặc "")
        prev = previous_translation or ""
        diff = get_word_diff_with_context(prev, translated_text)

        # Lưu lịch sử vào Firestore (an toàn)
        # Push realtime tới WS nếu có user kết nối
        await push_to_user(user_id_clean, {
            "type": "diff_update",
            "index": -1,  # REST gọi, không gắn index cụ thể
            "translated": translated_text,
            "diff": diff
        })
        # "preview": translated_text[:300]
        return {"status": "success", "translated": translated_text, "diff": diff}
    except Exception as e:
        return JSONResponse(status_code=500, content={"status": "error", "error": str(e)})

@app.get("/get-font-history")
async def get_font_history(user_id: str = Query(..., description="ID user")):
    """
    Lấy lịch sử chuyển đổi font của user
    """
    try:
        if not user_id:
            raise HTTPException(status_code=400, detail="Missing user_id")
        
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("font_conversion_history")
        docs = history_ref.stream()
        history = []
        for doc in docs:
            item = doc.to_dict()
            item['id'] = doc.id  # Thêm id để Flutter xóa từng item
            history.append(item)
        # Sắp xếp theo timestamp giảm dần (mới nhất lên đầu)
        history.sort(key=lambda x: x.get('timestamp', 0), reverse=True)
        return {"history": history}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/delete-font-history")
async def delete_font_history(user_id: str = Query(...), history_id: str = Query(...)):
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("font_conversion_history").document(history_id)

        if not history_ref.get().exists:
            raise HTTPException(status_code=404, detail="Mục lịch sử không tồn tại")

        history_ref.delete()
        return {"status": "success", "message": f"Đã xóa mục lịch sử {history_id}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/clear-font-history")
async def clear_font_history(user_id: str = Query(...)):
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("font_conversion_history")
        docs = history_ref.stream()
        count = 0
        for doc in docs:
            doc.reference.delete()
            count += 1
        return {"status": "success", "deleted": count, "message": f"Đã xóa {count} mục lịch sử"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/delete-image-history")
async def delete_image_history(
    user_id: str = Query(..., description="ID user"),
    history_id: str = Query(..., description="ID mục lịch sử")
):
    """
    Xóa 1 mục lịch sử chuyển đổi hình ảnh.
    """
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("image_conversion_history").document(history_id)

        if not history_ref.get().exists:
            raise HTTPException(status_code=404, detail="Mục lịch sử không tồn tại")

        history_ref.delete()

        return {
            "status": "success",
            "message": f"Đã xóa mục lịch sử {history_id}"
        }

    except Exception as e:
        print("❌ ERROR /delete-image-history:", e)
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/clear-image-history")
async def clear_image_history(
    user_id: str = Query(..., description="ID user")
):
    """
    Xóa toàn bộ lịch sử chuyển đổi hình ảnh.
    """
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("image_conversion_history")

        docs = history_ref.stream()
        count = 0
        for doc in docs:
            doc.reference.delete()
            count += 1

        return {
            "status": "success",
            "deleted": count,
            "message": f"Đã xóa {count} mục lịch sử của user {user_id}"
        }

    except Exception as e:
        print("❌ ERROR /clear-image-history:", e)
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    tmp = save_temp_file(file)
    try:
        ext = tmp.lower().rsplit(".", 1)[-1]
        fonts_found = set()
        paragraphs_info = []

        if ext == "docx":
            doc = Document(tmp)
            for i, para in enumerate(doc.paragraphs):
                para_fonts = set(run.font.name for run in para.runs if run.font.name)
                if not para_fonts:
                    para_fonts = {"Unknown"}
                fonts_found.update(para_fonts)
                paragraphs_info.append({
                    "index": i,
                    "text": para.text,
                    "fonts": list(para_fonts)
                })
        elif ext == "pdf":
            import fitz
            pdf = fitz.open(tmp)
            for i, page in enumerate(pdf):
                blocks = page.get_text("dict")["blocks"]
                for b in blocks:
                    for l in b.get("lines", []):
                        line_text = " ".join(s["text"] for s in l.get("spans", []))
                        line_fonts = set(s.get("font") for s in l.get("spans", []) if s.get("font"))
                        if line_text.strip():
                            fonts_found.update(line_fonts)
                            paragraphs_info.append({
                                "index": i,
                                "text": line_text.strip(),
                                "fonts": list(line_fonts)
                            })
        elif ext == "txt":
            with open(tmp, encoding="utf-8") as f:
                content = f.readlines()
            paragraphs_info = [{"index": i, "text": line.strip(), "fonts": ["N/A"]} for i, line in enumerate(content)]
            fonts_found = {"N/A"}
        else:
            return JSONResponse({"error": "Unsupported file type"}, status_code=400)

        return JSONResponse({
            "fonts_found": list(fonts_found),
            "paragraphs": paragraphs_info
        })
    finally:
        os.remove(tmp)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 👈 hoặc domain của Flutter Web nếu cần
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/outputs", StaticFiles(directory="outputs"), name="outputs")

@app.get("/get-server-ip")
def get_server_ip():
    """Trả về IP LAN thật của máy đang chạy backend"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Kết nối thử tới mạng để lấy IP thật (không gửi gói)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return {"ip": ip}

@app.get("/get-history")
async def get_history(user_id: str):
    """
    Lấy toàn bộ lịch sử chuyển đổi ảnh của user.
    Trả về danh sách gồm: filename, image_urls, timestamp.
    """
    try:
        if not user_id or user_id.strip() == "":
            return JSONResponse(
                status_code=400,
                content={"status": "error", "message": "Thiếu user_id trong request."}
            )

        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("image_conversion_history")

        history_docs = history_ref.order_by(
            "timestamp", direction=firestore.Query.DESCENDING
        ).stream()

        history_list = []
        for doc in history_docs:
            data = doc.to_dict() or {}
            ts = data.get("timestamp")
            history_list.append({
                "id": doc.id,
                "original_filename": data.get("original_filename", "Không có tên"),
                "image_urls": data.get("image_urls", []),
                "timestamp": ts.isoformat() if ts else None
            })

        return JSONResponse({
            "status": "success",
            "user_id": user_id,
            "history": history_list
        })

    except Exception as e:
        print(f"❌ Lỗi khi lấy lịch sử user {user_id}: {e}")
        return JSONResponse(
            status_code=500,
            content={"status": "error", "message": str(e)}
        )
    
@app.delete("/delete-translate-history")
async def delete_translate_history(
    user_id: str = Query(..., description="ID của user"),
    history_id: str = Query(..., description="ID của mục lịch sử cần xóa")
):
    """
    Xóa 1 mục lịch sử dịch của user.
    Truyền user_id và history_id qua query params
    VD: /delete-translate-history?user_id=xxx&history_id=yyy
    """
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("translate_history").document(history_id)

        if not history_ref.get().exists:
            raise HTTPException(status_code=404, detail="Mục lịch sử không tồn tại")

        history_ref.delete()

        return {
            "status": "success",
            "message": f"Đã xóa mục lịch sử {history_id}"
        }

    except Exception as e:
        print("❌ ERROR /delete-translate-history:", e)
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/clear-translate-history")
async def clear_translate_history(
    user_id: str = Query(..., description="ID của user")
):
    """
    Xóa toàn bộ lịch sử dịch của user.
    Truyền user_id qua query param
    VD: /clear-translate-history?user_id=xxx
    """
    try:
        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("translate_history")

        docs = history_ref.stream()
        count = 0
        for doc in docs:
            doc.reference.delete()
            count += 1

        return {
            "status": "success",
            "deleted": count,
            "message": f"Đã xóa {count} mục lịch sử dịch của user {user_id}"
        }

    except Exception as e:
        print("❌ ERROR /clear-translate-history:", e)
        raise HTTPException(status_code=500, detail=str(e))

    
@app.get("/get-translate-history")
async def get_translate_history(user_id: str):
    """
    Lấy toàn bộ lịch sử dịch tài liệu (docx/txt/pdf) của user.
    Trả về danh sách: filename, ngôn ngữ, link tải, timestamp.
    """
    try:
        if not user_id or user_id.strip() == "":
            return JSONResponse(
                status_code=400,
                content={"status": "error", "message": "Thiếu user_id trong request."}
            )
        
        # from google.cloud import firestore
        # db = firestore.Client()
        global db
        if db is None:
            raise Exception("Firestore chưa được khởi tạo!")


        user_ref = db.collection("users").document(user_id)
        history_ref = user_ref.collection("translate_history")

        history_docs = history_ref.order_by(
            "timestamp", direction=firestore.Query.DESCENDING
        ).stream()

        history_list = []
        for doc in history_docs:
            data = doc.to_dict() or {}
            ts = data.get("timestamp")
            history_list.append({
                "id": doc.id,
                "original_filename": data.get("original_filename", "Không có tên"),
                "source_lang": data.get("source_lang", "auto"),
                "target_lang": data.get("target_lang", "unknown"),
                "result_url": data.get("result_url", None),
                "thumbnail_url": data.get("thumbnail_url", None),  # ✅ thêm dòng này
                "timestamp": ts.isoformat() if ts else None,
            })

        return JSONResponse({
            "status": "success",
            "user_id": user_id,
            "history": history_list
        })

    except Exception as e:
        print(f"❌ Lỗi khi lấy lịch sử dịch của user {user_id}: {e}")
        return JSONResponse(
            status_code=500,
            content={"status": "error", "message": str(e)}
        )

# ===========================================================
# 🔹 Kiểm tra server
# ===========================================================
@app.get("/")
def home():
    return {"message": "EcoLive Font Converter API running ✅"}


# ===========================================================
# 🔹 Chạy local (debug)
# ===========================================================
def extract_text(file: UploadFile):
    ext = file.filename.split('.')[-1].lower()
    content = file.file.read()

    if ext == "pdf":
        reader = PdfReader(io.BytesIO(content))
        return "\n".join([page.extract_text() for page in reader.pages])
    elif ext == "docx":
        doc = Document(io.BytesIO(content))
        return "\n".join([para.text for para in doc.paragraphs])
    elif ext == "txt":
        return content.decode("utf-8")
    else:
        raise ValueError("Unsupported file format")

@app.post("/detect-language")
async def detect_language(file: UploadFile = File(...)):
    try:
        text = extract_text(file)
        if not text.strip():
            return {"detected_lang": "unknown"}

        detected = detect(text)
        return {"detected_lang": detected}
    except Exception as e:
        return {"error": str(e)}
    
# --- START: New endpoints for auto font workflow (detect-fonts, convert-font-all, convert-font-mapping) ---
import json
import requests
import tempfile

def _extract_paragraphs_from_docx(path: str):
    """Return list of paragraphs as {index, text, fonts} for docx"""
    paragraphs_info = []
    try:
        doc = Document(path)
        for i, para in enumerate(doc.paragraphs):
            try:
                para_fonts = set()
                for run in para.runs:
                    if run.font and run.font.name:
                        para_fonts.add(run.font.name)
                if not para_fonts:
                    para_fonts = {"Unknown"}
                text = para.text.strip() or "(Empty)"
                paragraphs_info.append({
                    "index": i,
                    "text": text,
                    "fonts": list(para_fonts)
                })
            except Exception as inner:
                logger.warning(f"⚠️ Lỗi đọc đoạn {i}: {inner}")
                paragraphs_info.append({
                    "index": i,
                    "text": "(Lỗi đọc đoạn)",
                    "fonts": ["Unknown"]
                })
    except Exception as e:
        logger.exception(f"❌ DOCX extract failed: {e}")
        return [{"index": 0, "text": "⚠️ Không thể đọc file DOCX", "fonts": ["Unknown"]}]
    return paragraphs_info

def _extract_paragraphs_from_pdf(path: str):
    """Return list of lines/paragraphs for pdf with font info similar to earlier logic"""
    paragraphs_info = []
    try:
        doc = fitz.open(path)
        for i, page in enumerate(doc):
            try:
                blocks = page.get_text("dict")["blocks"]
                for b in blocks:
                    for l in b.get("lines", []):
                        spans = l.get("spans", [])
                        if not spans:
                            continue
                        try:
                            line_text = " ".join(
                                s.get("text", "") for s in spans
                            ).strip()
                            if not line_text:
                                continue
                            line_fonts = set(
                                s.get("font") for s in spans if s.get("font")
                            ) or {"Unknown"}
                            paragraphs_info.append({
                                "index": i,
                                "text": line_text,
                                "fonts": list(line_fonts),
                            })
                        except Exception as span_err:
                            logger.warning(f"⚠️ Lỗi đọc span PDF trang {i}: {span_err}")
            except Exception as page_err:
                logger.warning(f"⚠️ Lỗi đọc trang {i}: {page_err}")
        doc.close()
    except Exception as e:
        logger.exception(f"❌ PDF extract failed: {e}")
        return [{"index": 0, "text": "⚠️ Không thể đọc file PDF", "fonts": ["Unknown"]}]
    return paragraphs_info

@app.post("/detect-fonts")
async def detect_fonts(payload: dict = Body(...)):
    """
    Phát hiện font trong file từ URL S3.
    Gửi JSON: { "file_url": "https://..." }
    """
    logger.info(f"📩 Payload detect-fonts: {payload}")
    tmp_path = None
    try:
        file_url = payload.get("file_url") or payload.get("url")
        if not file_url:
            logger.warning("⚠️ Thiếu file_url hoặc url trong payload")
            return JSONResponse({"error": "Thiếu file_url hoặc url"}, status_code=400)

        if not file_url.startswith(("http://", "https://")):
            logger.warning(f"⚠️ URL không hợp lệ: {file_url}")
            return JSONResponse({"error": f"URL không hợp lệ: {file_url}"}, status_code=400)

        # --- ✅ SỬA LỖI Ở ĐÂY ---
        ext = ""
        try:
            # 1. Phân tích đường dẫn từ URL
            parsed_path = urlparse(file_url).path
            # 2. Lấy tên file từ đường dẫn (ví dụ: 'file_cua_ban.pdf')
            filename = os.path.basename(parsed_path)
            # 3. Tách lấy đuôi file (ví dụ: 'pdf')
            # [1] để lấy phần sau dấu chấm, [1:] để bỏ dấu chấm, .lower()
            ext = os.path.splitext(filename)[1][1:].lower() 
            
            if not ext:
                raise ValueError("Không tìm thấy đuôi file trong URL")
                
            logger.info(f"✅ Phát hiện định dạng file từ URL: {ext}")

        except Exception as e:
            logger.warning(f"⚠️ Không thể lấy định dạng file từ URL: {file_url}. Lỗi: {e}")
            return JSONResponse({"error": "Không thể phân tích tên file từ URL"}, status_code=400)
        # --- KẾT THÚC SỬA LỖI ---

        logger.info(f"🔍 Đang tải file từ URL: {file_url}")
        tmp_path = download_file_from_url(file_url)
        logger.info(f"📁 File tải tạm: {tmp_path}")

        # Bây giờ, biến 'ext' đã có giá trị đúng (ví dụ: 'pdf')
        fonts_found = set()
        paragraphs = []

        if ext == "docx":
            try:
                paragraphs = _extract_paragraphs_from_docx(tmp_path)
                for p in paragraphs:
                    fonts_found.update(p.get("fonts", []))
            except Exception as e:
                logger.warning(f"⚠️ Lỗi đọc DOCX: {e}")
                paragraphs = [{"index": 0, "text": "Không thể đọc nội dung DOCX", "fonts": []}]

        elif ext == "pdf":
            try:
                paragraphs = _extract_paragraphs_from_pdf(tmp_path)
                for p in paragraphs:
                    fonts_found.update(p.get("fonts", []))
            except Exception as e:
                logger.warning(f"⚠️ Lỗi đọc PDF: {e}")
                paragraphs = [{"index": 0, "text": "Không thể đọc nội dung PDF", "fonts": []}]

        elif ext == "txt":
            with open(tmp_path, encoding="utf-8", errors="ignore") as f:
                lines = f.readlines()
            paragraphs = [{"index": i, "text": line.strip(), "fonts": ["N/A"]} for i, line in enumerate(lines)]
            fonts_found = {"N/A"}

        else:
            # Log này bây giờ sẽ có ý nghĩa (ví dụ: "Định dạng file không hỗ trợ: .zip")
            logger.warning(f"⚠️ Định dạng file không hỗ trợ: .{ext}")
            return JSONResponse({"error": f"Định dạng file không hỗ trợ: .{ext}"}, status_code=400)

        # ✅ Kết quả trả về
        logger.info(f"✅ Fonts phát hiện: {list(fonts_found)}")
        return JSONResponse({
            "fonts_found": list(fonts_found),
            "paragraphs": paragraphs
        })

    except Exception as e:
        logger.exception("❌ Lỗi trong /detect-fonts")
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        try:
            if tmp_path and os.path.exists(tmp_path):
                os.remove(tmp_path)
                logger.info(f"✅ Đã xóa file tạm: {tmp_path}")
        except Exception as cleanup_error:
            logger.warning(f"⚠️ Lỗi khi xóa file tạm: {cleanup_error}")

# --- Hàm helper để sửa font trong DOCX ---
# (Bạn đã có hàm này, nhưng đây là bản sạch hơn)
def set_run_font(run, font_name):
    try:
        run.font.name = font_name
        # Đặt font cho các ký tự phức tạp (ví dụ: Tiếng Việt)
        run._element.rPr.rFonts.set(qn('w:eastAsia'), font_name)
        run._element.rPr.rFonts.set(qn('w:ascii'), font_name)
        run._element.rPr.rFonts.set(qn('w:hAnsi'), font_name)
    except Exception as e:
        logger.warning(f"Lỗi set_run_font: {e}")

# --- Hàm helper để xử lý file DOCX ---
def process_docx_file(input_path, font_mapping):
    doc = Document(input_path)
    
    def apply_mapping_to_runs(runs):
        for r in runs:
            cur_font = r.font.name or ""
            matched = None
            for src, tgt in font_mapping.items():
                # So sánh chính xác hơn, tránh lỗi "TimesNewRoman" chứa "Arial"
                if src.lower().replace(" ", "") in cur_font.lower().replace(" ", ""):
                    matched = tgt
                    break
            if matched:
                set_run_font(r, matched)

    # Xử lý Paragraphs
    for p in doc.paragraphs:
        apply_mapping_to_runs(p.runs)

    # Xử lý Tables
    for table in doc.tables:
        for row in table.rows:
            for cell in row.cells:
                for p in cell.paragraphs:
                    apply_mapping_to_runs(p.runs)
    
    # (Bạn có thể thêm logic cho Headers/Footers nếu cần)
    doc.save(input_path) # Lưu đè lên file
    return input_path


# --- Endpoint chính đã được viết lại ---
@app.post("/convert-font-mapping")
async def convert_font_mapping(
    mapping: str = Form(...),
    file: UploadFile = File(None),
    file_url: str = Form(None),
    user_id: str = Form(None)
):
    tmp_path = None
    out_path = None
    original_name = ""
    # Các file tạm cần xóa
    temp_files_to_clean = []

    try:
        # 1. Parse mapping
        try:
            font_mapping = json.loads(mapping) if isinstance(mapping, str) else mapping
            if not isinstance(font_mapping, dict):
                raise ValueError("Mapping must be a JSON object.")
        except Exception as e:
            return JSONResponse({"error": f"Invalid mapping: {e}"}, status_code=400)

        # 2. Lấy file (Ưu tiên file_url)
        if file_url:
            # 💡 SỬA LỖI LẤY 'ext' (giống /detect-fonts)
            try:
                parsed_path = urlparse(file_url).path
                original_name = os.path.basename(parsed_path)
                ext = os.path.splitext(original_name)[1][1:].lower()
                if not ext: raise ValueError("No extension")
            except Exception:
                return JSONResponse({"error": "Không thể phân tích tên file từ URL"}, status_code=400)
            
            tmp_path = download_file_from_url(file_url, original_name) # Sửa hàm download để giữ tên file
            temp_files_to_clean.append(tmp_path)
        
        elif file:
            original_name = file.filename
            ext = os.path.splitext(original_name)[1][1:].lower()
            tmp_path = save_temp_file(file) # Giả sử hàm này trả về path
            temp_files_to_clean.append(tmp_path)
        else:
            return JSONResponse({"error": "Missing file or file_url"}, status_code=400)
        
        logger.info(f"Đang xử lý file: {original_name} (ext: {ext})")

        # -----------------------------------------------------
        # BẮT ĐẦU XỬ LÝ CHUYỂN ĐỔI
        # -----------------------------------------------------
        
        if ext == "docx":
            logger.info("Xử lý file DOCX...")
            out_path = process_docx_file(tmp_path, font_mapping)
            content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"

        elif ext == "pdf":
            logger.info("Xử lý file PDF (dùng quy trình PDF -> DOCX -> PDF)...")
            
            # 1. PDF -> DOCX
            logger.info("Bước 1: Chuyển PDF sang DOCX...")
            pdf_doc = aw.Document(tmp_path)
            tmp_docx_path = f"{tmp_path}_{uuid.uuid4().hex}.docx"
            temp_files_to_clean.append(tmp_docx_path)
            pdf_doc.save(tmp_docx_path)
            
            # 2. Sửa file DOCX
            logger.info("Bước 2: Sửa font trên file DOCX...")
            process_docx_file(tmp_docx_path, font_mapping)
            
            # 3. DOCX -> PDF (Lưu lại file kết quả)
            logger.info("Bước 3: Chuyển DOCX đã sửa về PDF...")
            final_doc = aw.Document(tmp_docx_path)
            out_path = f"{tmp_path}.mapped.pdf"
            temp_files_to_clean.append(out_path)
            final_doc.save(out_path)
            content_type = "application/pdf"

        else:
            return JSONResponse({"error": f"Unsupported file type: .{ext}"}, status_code=400)

        # 4. Upload kết quả lên S3
        logger.info(f"Bước 4: Upload kết quả {out_path} lên S3...")
        result_url = upload_to_s3(out_path, content_type=content_type)
        if not result_url:
            raise Exception("Failed to upload result file to S3")

        # 5. Ghi log Firestore
        try:
            record = {
                "original_filename": original_name,
                "result_url": result_url,
                "mapping": font_mapping,
                "mode": "mapping",
                "timestamp": firestore.SERVER_TIMESTAMP
            }
            if user_id:
                db.collection("users").document(user_id).collection("font_conversion_history").add(record)
            else:
                db.collection("conversion_history").add(record)
        except Exception as e:
            logger.warning(f"Firestore log failed: {e}")

        logger.info("✅ Xử lý thành công!")
        return JSONResponse({"status": "success", "result_url": result_url})

    except Exception as e:
        logger.exception("❌ /convert-font-mapping bị sập")
        return JSONResponse({"error": str(e)}, status_code=500)
    
    finally:
        # Dọn dẹp tất cả file tạm
        for p in temp_files_to_clean:
            try:
                if p and os.path.exists(p):
                    os.remove(p)
                    logger.info(f"Đã xóa file tạm: {p}")
            except Exception as e:
                logger.warning(f"Lỗi xóa file tạm {p}: {e}")

# --- HELPER: Hàm đổi font cho DOCX ---
def apply_font_to_docx(doc_path, target_font):
    """
    Hàm đổi font mạnh mẽ:
    1. Map tên font chung (Script, Serif...) sang font cụ thể.
    2. Đổi font của Style 'Normal' (ảnh hưởng toàn bài).
    3. Quét sạch từng ký tự trong Paragraph và Table để ép đổi font.
    """
    try:
        # 1. Map tên Font từ Flutter sang tên Font chuẩn của Word
        font_mapping = {
            "Serif": "Times New Roman",
            "Sans-serif": "Arial",
            "Script": "Monotype Corsiva", # Hoặc "Brush Script MT"
            "Times New Roman": "Times New Roman",
            "Arial": "Arial",
            "Calibri": "Calibri"
        }
        
        # Lấy tên font chuẩn, nếu không có trong map thì dùng chính nó
        real_font_name = font_mapping.get(target_font, target_font)
        
        print(f"🔄 Đang đổi font sang: {real_font_name} (Input: {target_font})")

        doc = Document(doc_path)

        # 2. Đổi Font mặc định của Style 'Normal' (Gốc rễ)
        try:
            style = doc.styles['Normal']
            style.font.name = real_font_name
            style._element.rPr.rFonts.set(qn('w:eastAsia'), real_font_name)
            style._element.rPr.rFonts.set(qn('w:ascii'), real_font_name)
            style._element.rPr.rFonts.set(qn('w:hAnsi'), real_font_name)
        except Exception:
            pass # Bỏ qua nếu file lỗi style

        # Hàm nội bộ để set font cho một đối tượng run
        def set_run_font_force(run, font_name):
            run.font.name = font_name
            # Xóa định dạng cũ nếu có để tránh xung đột
            if run._element.rPr is None:
                run._element.get_or_add_rPr()
            
            # Ép set font cho mọi hệ ngôn ngữ
            run._element.rPr.rFonts.set(qn('w:eastAsia'), font_name)
            run._element.rPr.rFonts.set(qn('w:ascii'), font_name)
            run._element.rPr.rFonts.set(qn('w:hAnsi'), font_name)
            run._element.rPr.rFonts.set(qn('w:cs'), font_name) # Complex Script

        # 3. Duyệt qua tất cả đoạn văn (Paragraphs)
        for p in doc.paragraphs:
            for r in p.runs:
                set_run_font_force(r, real_font_name)

        # 4. Duyệt qua tất cả bảng (Tables)
        for table in doc.tables:
            for row in table.rows:
                for cell in row.cells:
                    for p in cell.paragraphs:
                        for r in p.runs:
                            set_run_font_force(r, real_font_name)

        doc.save(doc_path)
        print(f"✅ Đã đổi font thành công: {doc_path}")
        
    except Exception as e:
        logger.error(f"❌ Lỗi apply font: {e}")

# 🟢 API 1: Chuyển đổi Font toàn bộ (Chế độ Full)
@app.post("/convert-font-all")
async def convert_font_all(
    file: UploadFile = File(...),
    target_font: str = Form(...),
    user_id: str = Form("anonymous"),
):
    tmp_path = save_temp_file(file)
    out_docx = f"{tmp_path}.docx"
    
    try:
        ext = file.filename.split('.')[-1].lower()
        
        # 1. Chuẩn hóa về DOCX
        if ext == "pdf":
            # PDF -> DOCX (Dùng Aspose)
            aw.Document(tmp_path).save(out_docx)
        elif ext == "docx":
            shutil.copy(tmp_path, out_docx)
        else:
             # TXT -> DOCX
             doc = Document()
             with open(tmp_path, "r", encoding="utf-8") as f:
                 doc.add_paragraph(f.read())
             doc.save(out_docx)

        # 2. Đổi Font
        apply_font_to_docx(out_docx, target_font)

        # 3. Upload S3
        s3_url = upload_to_s3(out_docx, 
            content_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            folder="exported_documents"
        )

        # 4. Lưu lịch sử
        try:
            db.collection("users").document(user_id).collection("font_conversion_history").add({
                "original_filename": file.filename,
                "result_url": s3_url,
                "target_font": target_font,
                "type": "font_full",
                "timestamp": firestore.SERVER_TIMESTAMP
            })
        except: pass

        return {"status": "success", "result_url": s3_url}

    except Exception as e:
        logger.error(traceback.format_exc())
        return JSONResponse(500, {"error": str(e)})
    finally:
        try:
            if os.path.exists(tmp_path): os.remove(tmp_path)
            if os.path.exists(out_docx): os.remove(out_docx)
        except: pass

# 🟢 API 2: Xuất file từ màn hình Từng phần (Font + Content)
@app.post("/export-font-doc")
async def export_font_doc(
    file: UploadFile = File(None), # File gốc
    user_id: str = Form(...),
    target_font: str = Form(...),
    segments: str = Form(...), # JSON list content
    output_format: str = Form("docx"), # docx hoặc pdf
):
    try:
        segments_list = json.loads(segments)
        cleanup_tmp_dir()
        
        temp_name = f"font_export_{uuid.uuid4().hex}"
        out_docx = os.path.join(TMP_DIR, f"{temp_name}.docx")
        final_out = os.path.join(TMP_DIR, f"{temp_name}.{output_format}")

        # 1. Tạo nội dung DOCX (Giữ định dạng gốc nếu có file)
        if file:
            original = save_temp_file(file)
            try:
                doc = Document(original)
                for i, para in enumerate(doc.paragraphs):
                    if i < len(segments_list):
                        new_txt = str(segments_list[i]).strip()
                        if new_txt:
                            if not para.runs: para.add_run(new_txt)
                            else:
                                para.runs[0].text = new_txt
                                for r in para.runs[1:]: r.text = ""
                doc.save(out_docx)
            finally:
                if os.path.exists(original): os.remove(original)
        else:
            doc = Document()
            for txt in segments_list:
                doc.add_paragraph(str(txt))
            doc.save(out_docx)

        # 2. Áp dụng Font mới
        apply_font_to_docx(out_docx, target_font)

        # 3. Nếu cần PDF -> Convert
        content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        if output_format == "pdf":
            aw.Document(out_docx).save(final_out)
            content_type = "application/pdf"
        else:
            shutil.move(out_docx, final_out)

        # 4. Upload S3 & Lưu lịch sử
        s3_url = upload_to_s3(final_out, content_type=content_type, folder="exported_documents")
        
        try:
            db.collection("users").document(user_id).collection("font_conversion_history").add({
                "original_filename": file.filename if file else "font_edited.doc",
                "result_url": s3_url,
                "target_font": target_font,
                "type": f"font_partial_{output_format}",
                "timestamp": firestore.SERVER_TIMESTAMP
            })
        except: pass

        return FileResponse(final_out, filename=f"converted.{output_format}")

    except Exception as e:
        logger.error(traceback.format_exc())
        return JSONResponse(500, {"error": str(e)})
    
# 🟢 API MỚI: Xuất file với nhiều Font hỗn hợp (Mixed Fonts)
@app.post("/export-font-doc-mixed")
async def export_font_doc_mixed(
    segments_data: str = Form(...), # JSON List: [{"text": "...", "font": "...", "is_new_paragraph": true/false}]
    user_id: str = Form(...),
    output_format: str = Form("docx"),
    original_filename: str = Form("document_edited.docx"),
):
    try:
        segments = json.loads(segments_data)
        cleanup_tmp_dir()
        
        temp_name = f"mixed_font_{uuid.uuid4().hex}"
        out_docx = os.path.join(TMP_DIR, f"{temp_name}.docx")
        final_out = os.path.join(TMP_DIR, f"{temp_name}.{output_format}")

        doc = Document()

        # 🟢 1. BẢNG ÁNH XẠ TÊN FONT (QUAN TRỌNG)
        # Word cần tên chính xác, không dùng tên chung chung
        font_mapping = {
            "Script": "Monotype Corsiva",   # Hoặc "Brush Script MT"
            "Serif": "Times New Roman",
            "Sans-serif": "Arial",
            "Arial": "Arial",
            "Calibri": "Calibri",
            "Times New Roman": "Times New Roman"
        }
        
        # Biến lưu đoạn văn hiện tại
        current_paragraph = None 

        for seg in segments:
            text = seg.get("text", "")
            raw_font_name = seg.get("font", "Arial")
            is_new_paragraph = seg.get("is_new_paragraph", False)

            # 🟢 2. Lấy tên font thực tế từ Mapping
            # Nếu không có trong map thì dùng chính tên gửi lên
            real_font_name = font_mapping.get(raw_font_name, raw_font_name)

            # Nếu là đoạn mới hoặc chưa có đoạn nào -> Tạo paragraph mới
            if is_new_paragraph or current_paragraph is None:
                current_paragraph = doc.add_paragraph()

            # Thêm run (chuỗi ký tự) vào paragraph hiện tại
            run = current_paragraph.add_run(text)
            
            # Set Font cho Run này
            try:
                run.font.name = real_font_name
                run._element.rPr.rFonts.set(qn('w:eastAsia'), real_font_name)
                run._element.rPr.rFonts.set(qn('w:ascii'), real_font_name)
                run._element.rPr.rFonts.set(qn('w:hAnsi'), real_font_name)
                run._element.rPr.rFonts.set(qn('w:cs'), real_font_name)
            except Exception as e:
                print(f"⚠️ Lỗi set font {real_font_name}: {e}")

        doc.save(out_docx)

        # Convert sang PDF nếu cần
        content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        if output_format == "pdf":
            try:
                logger.info("🚀 Đang gọi CloudConvert để tạo PDF...")
                
                # Gọi hàm CloudConvert vừa viết ở Bước 3
                convert_docx_to_pdf_cloudconvert(out_docx, final_out)
                
                content_type = "application/pdf"
                logger.info("✅ Convert PDF thành công!")
                
            except Exception as pdf_err:
                logger.error(f"❌ Lỗi convert PDF: {pdf_err}")
                # Fallback: Trả về DOCX nếu lỗi (để app không crash)
                return JSONResponse(
                    status_code=200, 
                    content={
                        "status": "partial_success",
                        "message": "Lỗi tạo PDF (CloudConvert), đã trả về DOCX.",
                        "result_url": upload_to_s3(out_docx, content_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document", folder="exported_documents")
                    }
                )
        else:
            # Nếu chọn DOCX thì chỉ cần đổi tên file
            shutil.move(out_docx, final_out)

        s3_url = upload_to_s3(final_out, content_type=content_type, folder="exported_documents")

        try:
            # Làm sạch user_id
            user_id_clean = (user_id or "anonymous_user").strip()
            
            # Tạo bản ghi lịch sử
            history_data = {
                "original_filename": original_filename,
                "result_url": s3_url,
                "target_font": "Tùy chỉnh (Mixed)", # Đánh dấu là file chỉnh nhiều font
                "type": f"mixed_{output_format}",
                "timestamp": firestore.SERVER_TIMESTAMP
            }

            # Lưu vào collection font_conversion_history của user
            db.collection("users").document(user_id_clean).collection("font_conversion_history").add(history_data)
            logger.info(f"✅ Đã lưu lịch sử cho user {user_id_clean}")
            
        except Exception as db_err:
            # Log lỗi nhưng không làm fail request chính
            logger.error(f"⚠️ Lỗi lưu lịch sử: {db_err}")

        return JSONResponse({
            "status": "success",
            "result_url": s3_url
        })

    except Exception as e:
        logger.error(traceback.format_exc())
        return JSONResponse(status_code=500, content={"error": str(e)})

# --- END new endpoints ---

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

# --- Export PDF (Mới thêm) ---
@app.post("/export-pdf")
async def export_pdf(
    file: UploadFile = File(None),
    user_id: str = Form(...),
    target_lang: Optional[str] = Form(None),
    segments: str = Form(...),
):
    try:
        segments_list = json.loads(segments)
        cleanup_tmp_dir()
        
        # Tạo tên file tạm
        temp_docx_name = f"temp_for_pdf_{uuid.uuid4().hex}.docx"
        temp_docx_path = os.path.join(TMP_DIR, temp_docx_name)
        
        out_pdf_name = f"translated_edited_{uuid.uuid4().hex[:8]}.pdf"
        out_pdf_path = os.path.join(TMP_DIR, out_pdf_name)

        # 1. TẠO DOCX TẠM (Logic y hệt export-docx để giữ định dạng)
        if file:
            original_tmp = save_temp_file(file)
            try:
                doc = Document(original_tmp)
                for i, para in enumerate(doc.paragraphs):
                    if i < len(segments_list):
                        new_text = segments_list[i]
                        if isinstance(new_text, dict): new_text = new_text.get("translated", "")
                        new_text = str(new_text).strip()
                        if new_text:
                            if not para.runs: para.add_run(new_text)
                            else:
                                para.runs[0].text = new_text
                                for run in para.runs[1:]: run.text = ""
                doc.save(temp_docx_path)
            finally:
                if os.path.exists(original_tmp): os.remove(original_tmp)
        else:
            doc = Document()
            for seg in segments_list:
                text = seg if isinstance(seg, str) else seg.get("translated", "")
                doc.add_paragraph(text)
                doc.add_paragraph("")
            doc.save(temp_docx_path)

        # 2. CHUYỂN DOCX -> PDF (Dùng Aspose)
        try:
            # Load file DOCX vừa tạo vào Aspose
            doc_aw = aw.Document(temp_docx_path)
            # Lưu sang PDF
            doc_aw.save(out_pdf_path)
            logger.info("✅ Chuyển đổi PDF thành công")
        except Exception as e:
            raise Exception(f"Lỗi convert PDF: {str(e)}")

        # 3. UPLOAD PDF LÊN S3
        s3_url = upload_to_s3(
            out_pdf_path, 
            content_type="application/pdf",
            folder="exported_documents"
        )

        # 4. LƯU LỊCH SỬ
        try:
            user_id_clean = (user_id or "anonymous_user").strip()
            db.collection("users").document(user_id_clean).collection("translate_history").add({
                "original_filename": (file.filename.rsplit('.', 1)[0] + ".pdf") if file else "translated.pdf",
                "result_url": s3_url,
                "target_lang": target_lang,
                "source_lang": "auto",
                "type": "export_pdf", # Đánh dấu là PDF
                "thumbnail_url": None,
                "timestamp": firestore.SERVER_TIMESTAMP
            })
        except: pass

        # 5. TRẢ FILE PDF
        return FileResponse(
            out_pdf_path,
            media_type="application/pdf",
            filename="translated_document.pdf"
        )

    except Exception as e:
        logger.error(traceback.format_exc())
        return JSONResponse(status_code=500, content={"status": "error", "message": str(e)})
    finally:
        # Dọn dẹp file tạm
        try:
            if os.path.exists(temp_docx_path): os.remove(temp_docx_path)
            # Không xóa out_pdf_path ngay để FileResponse còn đọc, nó sẽ được xóa bởi cleanup_tmp_dir sau
        except: pass

@app.post("/preview")
async def preview_file(file: UploadFile = None, file_url: str = Form(None)):
    """
    ✅ API preview nội dung file (5 dòng đầu tiên)
    Hỗ trợ:
    - Upload trực tiếp file
    - Hoặc truyền vào URL S3 (file_url)
    """
    try:
        # 🔹 Bước 1: Chuẩn bị file tạm
        if file_url:
            tmp = download_file_from_url(file_url)
            file_path = tmp.name
        elif file:
            with tempfile.NamedTemporaryFile(delete=False) as tmp:
                content = await file.read()
                tmp.write(content)
                file_path = tmp.name
        else:
            raise HTTPException(status_code=400, detail="Thiếu file hoặc file_url")

        # 🔹 Bước 2: Xác định loại file
        ext = os.path.splitext(file.filename if file else file_url)[-1].lower()

        preview_text = ""

        # 🟢 Trường hợp TXT
        if ext == ".txt":
            with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                lines = [line.strip() for line in f.readlines() if line.strip()]
                preview_text = "\n".join(lines[:5])

        # 🟢 Trường hợp DOCX
        elif ext == ".docx":
            doc = Document(file_path)
            lines = [p.text.strip() for p in doc.paragraphs if p.text.strip()]
            preview_text = "\n".join(lines[:5])

        # 🟢 Trường hợp PDF
        elif ext == ".pdf":
            reader = PdfReader(file_path)
            lines = []
            for page in reader.pages[:2]:  # đọc 2 trang đầu để đủ text
                text = page.extract_text() or ""
                for line in text.splitlines():
                    if line.strip():
                        lines.append(line.strip())
                    if len(lines) >= 5:
                        break
                if len(lines) >= 5:
                    break
            preview_text = "\n".join(lines)

        else:
            preview_text = f"Không hỗ trợ xem trước loại file: {ext}"

        # 🔹 Xóa file tạm
        try:
            os.remove(file_path)
        except Exception:
            pass

        return {"preview": preview_text}

    except Exception as e:
        print(f"[ERROR] /preview: {e}")
        raise HTTPException(status_code=500, detail=f"Lỗi khi tạo preview: {str(e)}")
    
@app.post("/preview-docx")    
async def preview_docx(file_url: str = Form(...)):
    """Return text preview of DOCX file"""
    try:
        path = download_file_from_url(file_url)
        from docx import Document
        doc = Document(path)
        text = "\n".join(p.text for p in doc.paragraphs[:5])
        return {"preview": text}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if os.path.exists(path):
            os.remove(path)
    
@app.post("/preview-pdf")
async def preview_pdf(file_url: str = Form(...)):
    """Return text preview of PDF file"""
    try:
        path = download_file_from_url(file_url)
        import fitz
        doc = fitz.open(path)
        text = ""
        for page in doc[:2]:
            text += page.get_text("text") + "\n"
        doc.close()
        return {"preview": text.strip()[:2000]}  # Giới hạn độ dài
    except Exception as e:
        return {"error": str(e)}
    finally:
        if os.path.exists(path):
            os.remove(path)

@app.exception_handler(Exception)
async def http_exception_handler(request: Request, exc: Exception):
    logger.error(f"Lỗi không xác định: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"error": f"Internal server error: {str(exc)}"},
    )

def download_file_from_url(file_url: str, original_filename: str = None) -> str:
    """
    Tải file từ URL (S3) và lưu tạm.
    - Trả về ĐƯỜNG DẪN (string) đến file tạm.
    - Tương thích với 1 hoặc 2 tham số.
    """
    try:
        if not file_url:
            raise ValueError("file_url không được rỗng")
            
        logger.info(f"Đang tải file từ URL: {file_url}")
        resp = requests.get(file_url, stream=True, timeout=30)
        resp.raise_for_status() # Báo lỗi nếu status > 400

        # Ưu tiên lấy đuôi file từ original_filename (nếu có)
        # Nếu không, lấy từ file_url
        filename_to_parse = original_filename if original_filename else file_url
        
        try:
            # Tách đuôi file từ tên file (bỏ qua query params)
            parsed_path = urlparse(filename_to_parse).path
            suffix = os.path.splitext(parsed_path)[1].lower()
        except Exception:
            suffix = "" # Nếu có lỗi, dùng đuôi rỗng

        # Tạo file tạm với đúng đuôi file
        tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
        
        for chunk in resp.iter_content(chunk_size=8192):
            if chunk:
                tmp.write(chunk)
        
        tmp.flush()
        tmp.close()
        
        logger.info(f"File tạm đã được lưu tại: {tmp.name}")
        return tmp.name # ✅ Trả về STRING ĐƯỜNG DẪN (sửa lỗi stat)

    except Exception as e:
        logger.exception(f"❌ Lỗi khi tải file từ URL: {file_url}")
        raise HTTPException(status_code=500, detail=str(e))