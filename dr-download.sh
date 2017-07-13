#!/bin/bash

#TODO Handle missing PrimaryAssetUri

url1=$(curl -Ls "http://www.dr.dk/mu/programcard?Slug=%22$1%22" | jq ".Data[0].PrimaryAssetUri" | tr -d '"') 

url2=$(curl -Ls ${url1} | jq '.Links[] | select(.Target=="HLS") | .Uri' | tr -d '"')

streamUrl=$(curl -Ls ${url2} | tail -n 1)

./hls-fetch --playlist ${streamUrl} -o "$1.mp4"