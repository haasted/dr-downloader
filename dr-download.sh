#!/bin/bash

#TODO Handle missing PrimaryAssetUri

data=$(curl -Ls "http://www.dr.dk/mu/programcard?Slug=%22$1%22" | jq -r "{uri: .Data[0].PrimaryAssetUri, title: .Data[0].Title, subtitle: .Data[0].Subtitle}") 

url1=$(echo ${data} | jq -r '.uri')
echo ${data} | jq -r '[.title, .subtitle] | join(" - ")'

url2=$(curl -Ls ${url1} | jq '.Links[] | select(.Target=="HLS") | .Uri' | tr -d '"')

if [ -z "$url2" ]; then
	echo "Program could not be found. It may have expired from the homepage."
	exit
fi

streamUrl=$(curl -Ls ${url2} | tail -n 1)

./hls-fetch/hls-fetch --playlist ${streamUrl} -o "$1.mp4"
printf "\n"