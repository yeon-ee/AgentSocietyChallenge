#!/bin/bash

# URL 리스트 및 디렉토리 매핑
declare -A urls=(
    # Industrial_and_Scientific
    ["Industrial_and_Scientific"]="https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Industrial_and_Scientific.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Industrial_and_Scientific.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Industrial_and_Scientific.csv.gz"

    # Musical_Instruments
    ["Musical_Instruments"]="https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Musical_Instruments.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Musical_Instruments.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Musical_Instruments.csv.gz"

    # Video_Games
    ["Video_Games"]="https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/review_categories/Video_Games.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/raw/meta_categories/meta_Video_Games.jsonl.gz
    https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_2023/benchmark/5core/rating_only/Video_Games.csv.gz"
)

# 데이터 디렉토리 생성
base_dir="data/Amazon"
mkdir -p "$base_dir"

# 카테고리별 다운로드 및 압축 해제
echo "Starting downloads and extraction..."
for category in "${!urls[@]}"; do
    category_dir="$base_dir/$category"
    mkdir -p "$category_dir"  # 카테고리별 디렉토리 생성
    
    # 해당 카테고리의 URL들 처리
    for url in ${urls[$category]}; do
        filename=$(basename "$url")  # URL에서 파일 이름 추출
        echo "Downloading: $url -> $category_dir"
        wget "$url" -P "$category_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to download: $url"
            exit 1
        fi
        
        # 압축 해제
        if [[ "$filename" == *.gz ]]; then
            echo "Extracting: $filename in $category_dir"
            gunzip "$category_dir/$filename"
            if [ $? -ne 0 ]; then
                echo "Failed to extract: $filename"
                exit 1
            fi
            echo "Deleting: $filename"
            rm -f "$category_dir/$filename"
        fi
    done
done

echo "All downloads and extractions completed successfully."
