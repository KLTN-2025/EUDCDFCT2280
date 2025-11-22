import socket
from fastapi import FastAPI, UploadFile, File, Form 
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi import Body
from fastapi import Request
import os, fitz, uuid
import shutil, os, uuid, json 
from typing import List, Dict 
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


TMP_DIR = tempfile.gettempdir()
TMP_DIR = "/tmp/ecolive"
os.makedirs(TMP_DIR, exist_ok=True)


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
def upload_to_s3(local_path: str, content_type="image/png") -> str:
    key = f"converted_image/{uuid.uuid4().hex}_{os.path.basename(local_path)}"
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

@app.post("/convert-to-image")
async def convert_to_image(file: UploadFile = File(...), image_type: str = Form("PNG"), user_id: str = Form("anonymous_user"),
    user_email: str = Form(None)):
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

        # Lưu theo cấu trúc users/{user_id}/image_conversion_history
        db.collection("users").document(user_id).collection("image_conversion_history").add({
            "original_filename": file.filename,
            "image_urls": s3_urls,
            "timestamp": firestore.SERVER_TIMESTAMP,
        })

        return JSONResponse({
            "status": "success",
            "image_urls": s3_urls,
            "user_id": user_id  # 🟢 gợi ý thêm, để dễ debug từ Flutter
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

# def download_file_from_url(file_url: str) -> str:
#     """Tải file từ URL (S3) và lưu tạm"""
#     try:
#         resp = requests.get(file_url, stream=True, timeout=30)
#         if resp.status_code != 200:
#             raise HTTPException(
#                 status_code=400,
#                 detail=f"Không thể tải file: {file_url} (status {resp.status_code})"
#             )

#         suffix = "." + file_url.split("?")[0].split(".")[-1] if "." in file_url.split("?")[0] else ""
#         tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
#         for chunk in resp.iter_content(chunk_size=8192):
#             if chunk:
#                 tmp.write(chunk)
#         tmp.flush()
#         tmp.close()
#         return tmp.name

#     except Exception as e:
#         logger.exception("❌ Lỗi khi tải file từ URL")
#         raise HTTPException(status_code=400, detail=str(e))

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

# @app.post("/detect-fonts")
# async def detect_fonts(payload: dict = Body(...)):
#     """
#     Phát hiện font trong file từ URL S3.
#     Gửi JSON: { "file_url": "https://..." }
#     """
#     logger.info(f"📩 Payload detect-fonts: {payload}")
#     tmp_path = None
#     try:
        
#         # 🧾 Ghi log payload để kiểm tra dữ liệu nhận được
#         logger.info(f"📩 Payload detect-fonts: {payload}")

#         file_url = payload.get("file_url") or payload.get("url")
#         if not file_url:
#             logger.warning("⚠️ Thiếu file_url hoặc url trong payload")
#             return JSONResponse({"error": "Thiếu file_url hoặc url"}, status_code=400)

#         if not file_url.startswith(("http://", "https://")):
#             logger.warning(f"⚠️ URL không hợp lệ: {file_url}")
#             return JSONResponse({"error": f"URL không hợp lệ: {file_url}"}, status_code=400)

#         logger.info(f"🔍 Đang tải file từ URL: {file_url}")
#         tmp_path = download_file_from_url(file_url)
#         logger.info(f"📁 File tải tạm: {tmp_path}")

#         # Xác định định dạng file
#         ext = tmp_path.lower().rsplit(".", 1)[-1] if "." in tmp_path else ""
#         fonts_found = set()
#         paragraphs = []

#         if ext == "docx":
#             try:
#                 paragraphs = _extract_paragraphs_from_docx(tmp_path)
#                 for p in paragraphs:
#                     fonts_found.update(p.get("fonts", []))
#             except Exception as e:
#                 logger.warning(f"⚠️ Lỗi đọc DOCX: {e}")
#                 paragraphs = [{"index": 0, "text": "Không thể đọc nội dung DOCX", "fonts": []}]

#         elif ext == "pdf":
#             try:
#                 paragraphs = _extract_paragraphs_from_pdf(tmp_path)
#                 for p in paragraphs:
#                     fonts_found.update(p.get("fonts", []))
#             except Exception as e:
#                 logger.warning(f"⚠️ Lỗi đọc PDF: {e}")
#                 paragraphs = [{"index": 0, "text": "Không thể đọc nội dung PDF", "fonts": []}]

#         elif ext == "txt":
#             with open(tmp_path, encoding="utf-8", errors="ignore") as f:
#                 lines = f.readlines()
#             paragraphs = [{"index": i, "text": line.strip(), "fonts": ["N/A"]} for i, line in enumerate(lines)]
#             fonts_found = {"N/A"}

#         else:
#             logger.warning(f"⚠️ Định dạng file không hỗ trợ: .{ext}")
#             return JSONResponse({"error": f"Định dạng file không hỗ trợ: .{ext}"}, status_code=400)

#         # ✅ Kết quả trả về
#         logger.info(f"✅ Fonts phát hiện: {list(fonts_found)}")
#         return JSONResponse({
#             "fonts_found": list(fonts_found),
#             "paragraphs": paragraphs
#         })

#     except Exception as e:
#         logger.exception("❌ Lỗi trong /detect-fonts")
#         return JSONResponse({"error": str(e)}, status_code=500)
#     finally:
#         try:
#             if tmp_path and os.path.exists(tmp_path):
#                 os.remove(tmp_path)
#         except Exception as cleanup_error:
#             logger.warning(f"⚠️ Lỗi khi xóa file tạm: {cleanup_error}")
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

@app.post("/convert-font-all")
async def convert_font_all(
    file: UploadFile = File(None),
    file_url: str = Form(None),
    target_font: str = Form(...),
    force_all: str = Form("1"),
    user_id: str = Form(None)
):
    """
    Convert all fonts in the document to target_font.
    Accepts either uploaded file or file_url (S3).
    Returns result_url (uploaded to S3) and logs to Firestore.
    """
    tmp_path = None
    out_path = None
    try:
        # 1) Get local file
        if file_url:
            tmp_path = download_file_from_url(file_url)
            original_name = file_url.split("/")[-1].split("?")[0]
        elif file:
            tmp_path = save_temp_file(file)
            original_name = file.filename
        else:
            return JSONResponse({"error": "Missing file or file_url"}, status_code=400)

        ext = tmp_path.lower().rsplit(".", 1)[-1] if "." in tmp_path else ""
        force_flag = bool(int(force_all)) if force_all is not None else True

        # 2) Convert based on extension
        if ext == "docx":
            out_path = convert_docx_to_font(tmp_path, target_font, force_flag)
            content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        elif ext == "pdf":
            out_path = convert_pdf_simple_to_pdf(tmp_path, target_font, force_flag)
            content_type = "application/pdf"
        else:
            return JSONResponse({"error": f"Unsupported file type: .{ext}"}, status_code=400)

        # 3) Upload to S3
        result_url = upload_to_s3(out_path, content_type=content_type)

        # 4) Log to Firestore
        try:
            record = {
                "original_filename": original_name,
                "file_url": file_url if file_url else None,
                "result_url": result_url,
                "target_font": target_font,
                "mode": "all",
                "timestamp": firestore.SERVER_TIMESTAMP
            }
            if user_id:
                db.collection("users").document(user_id).collection("font_conversion_history").add(record)
            else:
                db.collection("conversion_history").add(record)
        except Exception as e:
            logger.warning(f"Failed to log conversion to Firestore: {e}")

        return JSONResponse({"status": "success", "result_url": result_url})
    except HTTPException as he:
        raise he
    except Exception as e:
        logger.exception("Error in /convert-font-all")
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        # cleanup
        try:
            for p in [tmp_path, out_path]:
                if p and os.path.exists(p):
                    os.remove(p)
        except:
            pass

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

# @app.post("/convert-font-mapping")
# async def convert_font_mapping(
#     mapping: str = Form(...),
#     file: UploadFile = File(None),
#     file_url: str = Form(None),
#     user_id: str = Form(None)
# ):
#     """
#     Convert fonts based on mapping for DOCX + PDF.
#     PDF version includes auto line-wrapping for layout stability.
#     """
#     tmp_path = None
#     out_path = None
#     try:
#         # Parse mapping
#         try:
#             font_mapping = json.loads(mapping) if isinstance(mapping, str) else mapping
#             if not isinstance(font_mapping, dict):
#                 raise ValueError("Mapping must be a JSON object.")
#         except Exception as e:
#             return JSONResponse({"error": f"Invalid mapping: {e}"}, status_code=400)

#         # Get local file
#         if file_url:
#             tmp_path = download_file_from_url(file_url)
#             original_name = file_url.split("/")[-1].split("?")[0]
#         elif file:
#             tmp_path = save_temp_file(file)
#             original_name = file.filename
#         else:
#             return JSONResponse({"error": "Missing file or file_url"}, status_code=400)

#         ext = tmp_path.lower().rsplit(".", 1)[-1]

#         # -----------------------------------------------------
#         # DOCX Handling
#         # -----------------------------------------------------
#         if ext == "docx":
#             doc = Document(tmp_path)

#             def set_run_font(run, font_name):
#                 try:
#                     run.font.name = font_name
#                     r = run._element
#                     rPr = r.rPr
#                     if rPr is None:
#                         from docx.oxml import OxmlElement
#                         rPr = OxmlElement('w:rPr')
#                         r.insert(0, rPr)
#                     rFonts = rPr.rFonts
#                     if rFonts is None:
#                         from docx.oxml import OxmlElement
#                         rFonts = OxmlElement('w:rFonts')
#                         rPr.append(rFonts)
#                     rFonts.set(qn('w:ascii'), font_name)
#                     rFonts.set(qn('w:hAnsi'), font_name)
#                     rFonts.set(qn('w:eastAsia'), font_name)
#                 except Exception:
#                     pass

#             for p in doc.paragraphs:
#                 for r in p.runs:
#                     cur_font = r.font.name or ""
#                     matched = None
#                     for src, tgt in font_mapping.items():
#                         if src.lower() in cur_font.lower():
#                             matched = tgt
#                             break
#                     if matched:
#                         set_run_font(r, matched)

#             for table in doc.tables:
#                 for row in table.rows:
#                     for cell in row.cells:
#                         for p in cell.paragraphs:
#                             for r in p.runs:
#                                 cur_font = r.font.name or ""
#                                 matched = None
#                                 for src, tgt in font_mapping.items():
#                                     if src.lower() in cur_font.lower():
#                                         matched = tgt
#                                         break
#                                 if matched:
#                                     set_run_font(r, matched)

#             out_path = tmp_path + ".mapped.docx"
#             doc.save(out_path)
#             content_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"

#         # -----------------------------------------------------
#         # PDF Handling (word-wrap + layout-friendly)
#         # -----------------------------------------------------
#         elif ext == "pdf":
#             doc = fitz.open(tmp_path)
#             out_path = tmp_path + ".mapped.pdf"
#             c = canvas.Canvas(out_path)

#             try:
#                 from reportlab.pdfbase.cidfonts import UnicodeCIDFont
#                 pdfmetrics.registerFont(UnicodeCIDFont("HeiseiMin-W3"))  # Japanese fallback
#                 pdfmetrics.registerFont(UnicodeCIDFont("STSong-Light"))  # Simplified Chinese fallback
#                 pdfmetrics.registerFont(UnicodeCIDFont("HYSMyeongJo-Medium"))  # Korean fallback
#             except Exception:
#                 pass

#             for page_num, page in enumerate(doc):
#                 rect = page.rect
#                 width, height = rect.width, rect.height
#                 c.setPageSize((width, height))
#                 y_cursor = height - 40  # top margin
#                 left_margin = 40
#                 right_margin = width - 40
#                 line_spacing = 1.3  # spacing multiplier

#                 blocks = page.get_text("dict")["blocks"]
#                 for b in blocks:
#                     for line in b.get("lines", []):
#                         for span in line.get("spans", []):
#                             span_text = span.get("text", "").strip()
#                             if not span_text:
#                                 continue

#                             src_font = span.get("font", "")
#                             font_size = span.get("size", 12)

#                             # Find mapped font
#                             tgt_font = None
#                             for src, tgt in font_mapping.items():
#                                 if src.lower() in src_font.lower():
#                                     tgt_font = tgt
#                                     break
#                             if not tgt_font:
#                                 tgt_font = list(font_mapping.values())[0] if font_mapping else "Arial"

#                             # Register font safely
#                             try:
#                                 ttf_path = ensure_font_available(tgt_font)
#                                 reg_name = f"{tgt_font}_{uuid.uuid4().hex[:6]}"
#                                 pdfmetrics.registerFont(TTFont(reg_name, ttf_path))
#                                 use_font = reg_name
#                             except Exception:
#                                 use_font = "Helvetica"

#                             c.setFont(use_font, float(font_size))

#                             # Word wrap
#                             max_width = right_margin - left_margin
#                             wrapped_lines = []
#                             words = span_text.split()
#                             current_line = ""
#                             for word in words:
#                                 test_line = (current_line + " " + word).strip()
#                                 w = pdfmetrics.stringWidth(test_line, use_font, font_size)
#                                 if w > max_width and current_line:
#                                     wrapped_lines.append(current_line)
#                                     current_line = word
#                                 else:
#                                     current_line = test_line
#                             if current_line:
#                                 wrapped_lines.append(current_line)

#                             # Draw lines
#                             for wrapped in wrapped_lines:
#                                 if y_cursor < 40:
#                                     c.showPage()
#                                     y_cursor = height - 40
#                                     c.setPageSize((width, height))
#                                     c.setFont(use_font, float(font_size))
#                                 c.drawString(left_margin, y_cursor, wrapped)
#                                 y_cursor -= (font_size * line_spacing)

#                     y_cursor -= 10  # space between blocks

#                 c.showPage()
#             c.save()
#             doc.close()
#             content_type = "application/pdf"

#         else:
#             return JSONResponse({"error": f"Unsupported file type: .{ext}"}, status_code=400)

#         # Upload result
#         result_url = upload_to_s3(out_path, content_type=content_type)

#         # Log Firestore
#         try:
#             record = {
#                 "original_filename": original_name,
#                 "result_url": result_url,
#                 "mapping": font_mapping,
#                 "mode": "mapping",
#                 "timestamp": firestore.SERVER_TIMESTAMP
#             }
#             if user_id:
#                 db.collection("users").document(user_id).collection("font_conversion_history").add(record)
#             else:
#                 db.collection("conversion_history").add(record)
#         except Exception as e:
#             logger.warning(f"Firestore log failed: {e}")

#         return JSONResponse({"status": "success", "result_url": result_url})

#     except Exception as e:
#         logger.exception("convert-font-mapping failed")
#         return JSONResponse({"error": str(e)}, status_code=500)
#     finally:
#         for p in [tmp_path, out_path]:
#             try:
#                 if p and os.path.exists(p):
#                     os.remove(p)
#             except:
#                 pass

# --- END new endpoints ---

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

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
# async def preview_pdf(file: UploadFile = None, file_url: str = Form(None)):
#     """
#     ✅ API đọc trang đầu tiên của file PDF
#     - Có thể nhận file upload trực tiếp
#     - Hoặc nhận URL từ S3 (file_url)
#     """
#     try:
#         # 🔹 Tạo file tạm từ file upload hoặc URL
#         if file_url:
#             tmp = download_file_from_url(file_url)
#             file_path = tmp.name
#         elif file:
#             with tempfile.NamedTemporaryFile(delete=False) as tmp:
#                 tmp.write(await file.read())
#                 file_path = tmp.name
#         else:
#             raise HTTPException(status_code=400, detail="Thiếu file hoặc file_url")

#         # 🔹 Đọc nội dung PDF
#         reader = PdfReader(file_path)
#         if not reader.pages:
#             raise HTTPException(status_code=400, detail="Không đọc được nội dung PDF")

#         text = reader.pages[0].extract_text() or "Không có nội dung đọc được"

#         # 🔹 Giới hạn preview cho gọn (nếu trang dài quá)
#         preview_text = "\n".join(text.splitlines()[:50])

#         # 🔹 Xóa file tạm
#         try:
#             os.remove(file_path)
#         except Exception:
#             pass

#         return {"preview": preview_text}

#     except Exception as e:
#         print(f"[ERROR] /preview-pdf: {e}")
#         raise HTTPException(status_code=500, detail=f"Lỗi xử lý PDF: {str(e)}")
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

# def download_file_from_url(file_url: str):
#     """
#     ✅ Tải file từ S3 hoặc URL bất kỳ về máy tạm.
#     - Hỗ trợ file lớn, stream chunk-by-chunk.
#     - Trả về đối tượng NamedTemporaryFile, có thể đọc từ .name.
#     - File sẽ được tự động xóa khi đóng hoặc exit process (delete=True).
#     """
#     if not file_url:
#         raise ValueError("Thiếu file_url để tải file")

#     try:
#         # Dùng stream để tránh đọc toàn bộ vào RAM
#         response = requests.get(file_url, stream=True, timeout=30)
#         response.raise_for_status()

#         # Tạo file tạm, đuôi giữ nguyên nếu có thể (VD: .pdf, .docx)
#         suffix = '.' + file_url.split('.')[-1].lower() if '.' in file_url else ''
#         tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)

#         # Ghi dữ liệu chunk-by-chunk để tránh chiếm RAM
#         for chunk in response.iter_content(chunk_size=8192):
#             if chunk:
#                 tmp.write(chunk)

#         tmp.flush()
#         tmp.seek(0)
#         return tmp

#     except requests.exceptions.RequestException as e:
#         raise RuntimeError(f"Lỗi tải file từ URL: {e}")
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