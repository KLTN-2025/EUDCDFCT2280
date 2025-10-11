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
from fastapi.middleware.cors import CORSMiddleware
import os
from google.cloud import firestore
# from docx2pdf import convert
import re
from reportlab.pdfbase.cidfonts import UnicodeCIDFont


# cred_path = "/etc/secrets/firebase-key.json"
# db = firestore.Client.from_service_account_json(cred_path)
# 🔹 Xác định đường dẫn chính xác đến file JSON trong thư mục backend
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
cred_path = os.path.join(BASE_DIR, "secrets/firebase-key.json")

# 🔹 Kết nối Firestore
db = firestore.Client.from_service_account_json(cred_path)
print("✅ Firestore connected successfully.")

# --- Load .env --- 
load_dotenv() 

# --- Firestore giữ nguyên --- 
db = firestore.Client() 
print("Firestore Project ID:", db.project) 

# --- AWS S3 Config --- 
S3_BUCKET = os.getenv("AWS_S3_BUCKET", "my-ecolive-storage") 
s3_client = boto3.client( 
    "s3", 
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"), 
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"), 
    region_name=os.getenv("AWS_DEFAULT_REGION", "ap-southeast-2") 
) 

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
def upload_to_s3(local_path: str) -> str:
    key = f"results/{uuid.uuid4().hex}_{os.path.basename(local_path)}"
    s3_client.upload_file(local_path, S3_BUCKET, key)

    # Generate presigned URL (1 day)
    url = s3_client.generate_presigned_url(
        "get_object",
        Params={"Bucket": S3_BUCKET, "Key": key},
        ExpiresIn=3600 * 24
    )
    return url


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
            doc = fitz.open(temp_path)
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

        # 🟢 Lưu log Firestore
        # db.collection("image_conversion_history").add({
        #     "original_filename": file.filename,
        #     "image_urls": s3_urls,
        #     "timestamp": firestore.SERVER_TIMESTAMP
        # })
        
        # 🟢 Lưu log Firestore theo từng user
        # Yêu cầu Flutter gửi thêm field user_id (hoặc email)
        # ví dụ: Form("user_id") hoặc từ token Firebase
        # user_id = "anonymous_user"  # fallback nếu chưa có user_id trong form
        # try:
        #     form_user_id = await file.form()  # Nếu bạn dùng FormData, có thể lấy từ đó
        # except:
        #     form_user_id = None

        # if form_user_id and "user_id" in form_user_id:
        #     user_id = form_user_id["user_id"]
        # 🟢 user_id đã nhận sẵn từ Form() ở tham số hàm
        # if not user_id:
        #     user_id = "anonymous_user"
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
    
    

    # except Exception as e:
    #     return JSONResponse({"error": str(e)}, status_code=500)

    # finally:
    #     # Xoá file tạm
    #     try:
    #         if os.path.exists(temp_path):
    #             os.remove(temp_path)
    #         for f in output_files:
    #             if os.path.exists(f):
    #                 os.remove(f)
    #     except:
    #         pass
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

@app.post("/translate-doc")
async def translate_doc(file: UploadFile = File(...), target_lang: str = Form("en")):
    tmp = save_temp_file(file)
    try:
        ext = tmp.lower().rsplit(".", 1)[-1]
        text = ""
        if ext == "docx":
            doc = Document(tmp)
            for p in doc.paragraphs:
                text += p.text + "\n"
        elif ext == "pdf":
            import fitz
            pdf = fitz.open(tmp)
            for page in pdf:
                text += page.get_text("text") + "\n"
        else:
            return JSONResponse({"error": "Unsupported file"}, status_code=400)

        # 🔹 Dịch qua Hugging Face
        response = requests.post(
            "https://api-inference.huggingface.co/models/Helsinki-NLP/opus-mt-mul-en",
            headers=HF_HEADERS,
            json={"inputs": text}
        )
        result = response.json()
        translated_text = result[0]["translation_text"] if isinstance(result, list) else text

        # ✅ Xuất ra DOCX mới
        out_docx = tmp + f".{target_lang}.docx"
        new_doc = Document()
        new_doc.add_paragraph(translated_text)
        new_doc.save(out_docx)

        url = upload_to_s3(out_docx)
        return JSONResponse({"result_url": url})
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    finally:
        try: os.remove(tmp)
        except: pass

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

# @app.get("/get-history")
# async def get_history(user_id: str):
#     """
#     Lấy toàn bộ lịch sử chuyển đổi ảnh của user.
#     Trả về danh sách gồm: filename, image_urls, timestamp.
#     """
#     try:
#         # 🟢 Tham chiếu đến user
#         user_ref = db.collection("users").document(user_id)
#         history_ref = user_ref.collection("image_conversion_history")

#         # 🟢 Lấy danh sách lịch sử, sắp xếp theo thời gian giảm dần
#         history_docs = history_ref.order_by("timestamp", direction=firestore.Query.DESCENDING).stream()

#         history_list = []
#         for doc in history_docs:
#             data = doc.to_dict()
#             history_list.append({
#                 "id": doc.id,
#                 "original_filename": data.get("original_filename"),
#                 "image_urls": data.get("image_urls"),
#                 "timestamp": data.get("timestamp").isoformat() if data.get("timestamp") else None
#             })

#         return JSONResponse({
#             "status": "success",
#             "user_id": user_id,
#             "history": history_list
#         })

#     except Exception as e:
#         print("❌ Lỗi khi lấy lịch sử:", e)
#         return JSONResponse(
#             status_code=500,
#             content={"status": "error", "message": str(e)}
#         )
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
