import socket
from fastapi import FastAPI, UploadFile, File, Form 
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
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
from PyPDF2 import PdfReader
import io, boto3, uuid

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
try:
    firestore_client = firestore.Client()
    logger.info("✅ Firestore connected successfully.")
    logger.info(f"Firestore Project ID: {firestore_client.project}")
except Exception as e:
    logger.error(f"❌ Firestore connection failed: {e}")
    firestore_client = None

app = FastAPI()

TMP_DIR = "/tmp/ecolive"
os.makedirs(TMP_DIR, exist_ok=True)


def save_temp_file(upload_file: UploadFile) -> str:
    ext = os.path.splitext(upload_file.filename)[1]
    tmp_path = os.path.join(TMP_DIR, f"{uuid.uuid4().hex}{ext}")
    with open(tmp_path, "wb") as f:
        shutil.copyfileobj(upload_file.file, f)
    return tmp_path


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
    key = f"results/{uuid.uuid4().hex}_{os.path.basename(local_path)}"
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

# 🟢 Đăng ký nhiều font sẵn có trong thư mục assets/fonts
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FONT_DIR = os.path.join(BASE_DIR, "../../assets/fonts")

CUSTOM_FONTS = {
    "Arial": os.path.join(FONT_DIR, "Arial.ttf"),
    "Calibri": os.path.join(FONT_DIR, "Calibri.ttf"),
    "SansSerif": os.path.join(FONT_DIR, "Sans-serif.ttf"),
    "Serif": os.path.join(FONT_DIR, "Serif.ttf"),
    "Script": os.path.join(FONT_DIR, "Script.ttf"),
}

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

# @app.post("/translate-doc")
# async def translate_doc(
#     file: UploadFile = File(...),
#     target_lang: str = Form(...)
# ):
#     try:
#         ext = file.filename.split('.')[-1].lower()
#         content = file.file.read()

#         # Trích xuất nội dung file
#         text = ""
#         if ext == "pdf":
#             reader = PdfReader(io.BytesIO(content))
#             text = "\n".join([page.extract_text() for page in reader.pages if page.extract_text()])
#         elif ext == "docx":
#             doc = Document(io.BytesIO(content))
#             text = "\n".join([p.text for p in doc.paragraphs])
#         elif ext == "txt":
#             text = content.decode("utf-8")
#         else:
#             return {"error": "Unsupported file format"}

#         # Dịch nội dung
#         # translated_text = GoogleTranslator(source='auto', target=target_lang).translate(text)
#         try:
#             translated_text = GoogleTranslator(source='auto', target=target_lang).translate(text)
#         except Exception as e:
#             print("⚠️ Deep-translator failed, fallback to safe chunk translation:", e)
#             translated_text = ""
#             for chunk in [text[i:i+3000] for i in range(0, len(text), 3000)]:
#                 try:
#                     translated_chunk = GoogleTranslator(source='auto', target=target_lang).translate(chunk)
#                     translated_text += translated_chunk + "\n"
#                 except:
#                     translated_text += chunk + "\n"

#         # Tạo file mới (giữ cấu trúc theo từng dòng)
#         new_doc = Document()
#         for line in translated_text.split("\n"):
#             new_doc.add_paragraph(line)
#         output_path = f"/tmp/{uuid.uuid4()}.docx"
#         new_doc.save(output_path)

#         # Upload lên S3
#         s3_key = f"results/{uuid.uuid4()}.docx"
#         s3.upload_file(output_path, BUCKET_NAME, s3_key)
#         result_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{s3_key}"

#         print("⚙️ target_lang:", target_lang)

#         # --- Trả về chuẩn hóa ---
#         return {
#             "status": "success",
#             "download_url": result_url,
#             "message": f"Dịch thành công ({target_lang.upper()})"
#         }
    

#     except Exception as e:
#         import traceback
#         print("❌ Error in /translate-doc:", traceback.format_exc())
#         return {"status": "error", "message": str(e)}
@app.post("/translate-doc")
async def translate_doc(
    file: UploadFile = File(...),
    target_lang: str = Form(...)
):
    try:
        import io, uuid
        from PyPDF2 import PdfReader
        from docx import Document
        from deep_translator import GoogleTranslator

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
        s3_key = f"results/{uuid.uuid4()}.docx"
        s3.upload_file(output_path, BUCKET_NAME, s3_key)
        result_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{s3_key}"

        # --- Trả về ---
        return {
            "status": "success",
            "original_preview": text[:1000],
            "translated_preview": translated_text[:1000],
            "result_url": result_url
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

