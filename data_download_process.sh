#!/bin/bash

# 데이터 저장 디렉토리 설정
RAW_DIR="/root/AgentSocietyChallenge/data/raw"
PROCESSED_DIR="/root/AgentSocietyChallenge/data/processed"

# 데이터 디렉토리 생성
mkdir -p "$RAW_DIR"

# URL 리스트
urls=(
    # Amazon 데이터셋
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Industrial_and_Scientific.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Industrial_and_Scientific.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Industrial_and_Scientific.csv.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Musical_Instruments.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Musical_Instruments.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Musical_Instruments.csv.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Video_Games.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Video_Games.jsonl.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Video_Games.csv.gz"

    # Goodreads 데이터셋
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_reviews_children.json.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_books_children.json.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_reviews_comics_graphic.json.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_books_comics_graphic.json.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_reviews_poetry.json.gz"
    "https://datarepo.eng.ucsd.edu/mcauley_group/gdrive/goodreads/byGenre/goodreads_books_poetry.json.gz"
)

# 다운로드 및 압축 해제
echo "Starting downloads and extraction..."
for url in "${urls[@]}"; do
    filename=$(basename "$url")  # URL에서 파일 이름 추출
    filepath="$RAW_DIR/$filename"
    extracted_file="${filepath%.gz}"  # .gz 제거한 파일 경로

    # 파일이 이미 다운로드되어 있고 압축 해제까지 되어 있다면 스킵
    if [[ -f "$extracted_file" ]]; then
        echo "Skipping (already extracted): $extracted_file"
        continue
    fi

    # 파일이 존재하지 않으면 다운로드
    if [[ -f "$filepath" ]]; then
        echo "File already exists: $filepath (Skipping download)"
    else
        echo "Downloading: $url"
        wget -q "$url" -P "$RAW_DIR"
        
        if [ $? -ne 0 ]; then
            echo "Failed to download: $url"
            exit 1
        fi
    fi

    # 압축 해제
    if [[ "$filename" == *.gz ]]; then
        echo "Extracting: $filepath"
        gunzip -f "$filepath"

        if [ $? -ne 0 ]; then
            echo "Failed to extract: $filename"
            exit 1
        fi
    fi
done

echo "All downloads and extractions completed successfully."

# 데이터 처리 실행
echo "Running data processing..."
python data_process.py --input "$RAW_DIR" --output "$PROCESSED_DIR"

if [ $? -eq 0 ]; then
    echo "Data processing completed successfully."
else
    echo "Data processing failed."
    exit 1
fi
