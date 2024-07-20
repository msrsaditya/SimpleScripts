#!/bin/bash

# A Simple Script to Download Any Movie From "soap2dayhd.co", Requires 'ffmpeg', 'wget'

mkdir -p "Movie"
cd "Movie" || exit

echo
echo "Enter Movie Name: \c"
read movie

echo
echo "Enter URL: \c"
read base

echo
echo "Enter End Segment: \c"
read end
echo

for i in $(seq 1 "$end"); do
  url=$(echo "$base" | sed "s/seg-[0-9][0-9]*-/seg-$i-/")
  output="${i}.mp4"
  wget --quiet --show-progress -O "$output" "${url}"
  printf "file '%d.mp4'\n" "$i" >> videos.txt
done

ffmpeg -f concat -i videos.txt -c copy "${movie}.mp4"

rm -f [0-9]*.mp4
rm -f videos.txt
