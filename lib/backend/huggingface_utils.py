import os, requests
HF_TOKEN = os.getenv("HF_TOKEN")
HF_HEADERS = {"Authorization": f"Bearer {HF_TOKEN}"}

def hf_ocr_image(image_path: str) -> str:
    url = "https://api-inference.huggingface.co/models/microsoft/trocr-base-printed"
    with open(image_path, "rb") as f:
        response = requests.post(url, headers=HF_HEADERS, data=f.read())
    response.raise_for_status()
    result = response.json()
    if isinstance(result, list) and "generated_text" in result[0]:
        return result[0]["generated_text"]
    return ""

def hf_translate(text: str, model: str = "Helsinki-NLP/opus-mt-en-vi") -> str:
    url = f"https://api-inference.huggingface.co/models/{model}"
    payload = {"inputs": text}
    response = requests.post(url, headers=HF_HEADERS, json=payload)
    response.raise_for_status()
    result = response.json()
    if isinstance(result, list) and "translation_text" in result[0]:
        return result[0]["translation_text"]
    return text
