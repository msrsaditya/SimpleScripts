#!/bin/sh

# Script For Downloading Any Movie You Want From "soap2dayz.xyz"

mkdir -p "Movies" # Create a "Movies" folder if it doesn't exist 
cd "Movies" || exit # and navigate into it.

# Prompt for inputs
read -p "Enter Movie Name: " movie_name
read -p "Enter end value Value of Movie Stream: " end_value
read -p "Enter URL: " segment_url_base

# Download video segments
for ((segment_num = 1; segment_num <= end_value; segment_num++)); do # Loop from 1 to end value to generate all segments of movie
  segment_url=$(echo "$segment_url_base" | sed "s/seg-[0-9]\+/seg-$segment_num/") # Generate URL for downloading that video segment
  output_file="${segment_num}.mp4" # Save it in integer.mp4 format
  wget --quiet --show-progress -O "$output_file" "$segment_url" # Download that segment with wget
done

# Create a concatenated video (Movie) using ffmpeg
for ((segment_num = 1; segment_num <= end_value; segment_num++)); do
  printf "file '%d.mp4'\n" "$segment_num" >> video_list.txt # Store all the file names in a txt file for later use in concatenation
done

ffmpeg -f concat -i video_list.txt -c copy "${movie_name}.mp4" # concatenate all files from txt file to a single file (Movie)

# Clean up - Remove everything except the final movie
rm -f [0-9]*.mp4 # Remove all video segments
rm -f video_list.txt # Remove the txt file used in concatenation
