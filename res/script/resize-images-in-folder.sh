#!/usr/bin/env bash
# for file in *.{png,jpg,jpeg,webp}; do convert $file -resize x350\> $file; done

# Initialize overwrite flag
overwrite=false

# Define help message
help_message="Usage: resize_images.sh [-f|--force] [-h|--help] <directory>
Options:
  -f, --force  Overwrite original image files with resized ones.
  -h, --help   Display this help message and exit."

# Parse options
TEMP=$(getopt -o fh --long force,help -n 'resize_images.sh' -- "$@")
eval set -- "$TEMP"
while true; do
  case "$1" in
    -f|--force)
      overwrite=true
      shift
      ;;
    -h|--help)
      echo "$help_message"
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Invalid option: $1" 1>&2
      echo "$help_message"
      exit 1
      ;;
  esac
done

# Check if directory is not supplied
if [ -z "$1" ]
then
    echo "No directory supplied."
    echo "$help_message"
    exit 1
fi

# Check if directory exists
if [ ! -d "$1" ]
then
    echo "Directory $1 does not exist"
    exit 1
fi

# Change to the provided directory
cd "$1"

# Perform the convert operation
for file in *.{png,jpg,jpeg,webp}
do
    # Check if file exists
    if [ -f "$file" ]
    then
        # Extract filename and extension
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        # Create new filename
        newfile="${filename}_resized.${extension}"

        # If overwrite flag is set, overwrite original file
        if [ "$overwrite" = true ]
        then
            convert "$file" -resize x350\> "$file"
        else
            convert "$file" -resize x350\> "$newfile"
        fi
    fi
done
