#!/bin/bash

echo "uploading to s3..."

json_dir="coin_json"

mkdir "$json_dir"
for markdown_file in lib/*.md
do
  json_file=$(basename $markdown_file | sed -e 's/.md/.json/')
  bin/jsonify.sh "$markdown_file" > "$json_dir/$json_file"
done
aws s3 sync "./$json_dir" s3://coininfo --delete
