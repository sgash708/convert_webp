#!/bin/bash

# REF: https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website
echo "Setting up watches.";

# Jpeg向け非可逆cwebpオプション
JPEG_CWEBP_OPTS="-q 75 -m 4"
# PNG向け可逆cwebpオプション
PNG_CWEBP_OPTS="-lossless"

<< COMMENT
inotifywait: This command watches for changes to a certain directory.
-q: This option will tell inotifywait to be quiet and not produce a lot of output.
-m: This option will tell inotifywait to run indefinitely and not exit after receiving a single event.
-r: This option will set up watchers recursively, watching a specified directory and all its sub-directories.
--format: This option tells inotifywait to monitor changes using the event name followed by the file path. The events we want to monitor are close_write (triggered when a file is created and completely written to the disk), moved_from and moved_to (triggered when a file is moved), and delete (triggered when a file is deleted).
$1: This positional parameter holds the path of the changed files.
COMMENT

# watch for any created, moved, or deleted image files
inotifywait -q -m -r --format '%e %w%f' -e close_write -e moved_from -e moved_to -e delete $1 | grep -i -E '\.(jpe?g|png)$' --line-buffered \
| while read operation path; do
  webp_path="$(sed 's/\.[^.]*$/.webp/' <<< `$path`)";
  # if the file is moved or deleted
  if [[ $operation = "MOVED_FROM" ]] || [[ $operation = "DELETE" ]]; then
    if [[ -f "$webp_path" ]]; then
      $(rm -f "$webp_path");
    fi;
  # if new file is created
  elif [[ $operation = "CLOSE_WRITE,CLOSE" ]] || [[ $operation = "MOVED_TO" ]]; then
    if [[ $(grep -i '\.png$' <<< "$path") ]]; then
      $(cwebp -quiet "$PNG_CWEBP_OPTS" "$path" -o "$webp_path");
    else
      $(cwebp -quiet "$JPEG_CWEBP_OPTS" "$path" -o "$webp_path");
    fi;
  fi;
done;