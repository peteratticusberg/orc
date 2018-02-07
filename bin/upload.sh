#!/bin/bash

echo "uploading to s3..."

is_aws_installed="$(which aws)"
if [ -z "$is_aws_installed" ]; then
  error_msg="ERROR: The aws cli must be installed to run this command. For installation instructions see https://docs.aws.amazon.com/cli/latest/userguide/installing.html"
  echo -e "\033[0;31m$error_msg\033[0m"
  exit 1
fi

bucket_name="$1"
if [ -z "$bucket_name" ]; then
  error_msg="ERROR: No bucket name specified. To specify a bucket name, pass it as the first argument to this command, e.g. \`bin/upload.sh my-bucket-name\`"
  echo -e "\033[0;31m$error_msg\033[0m"
  exit 1
fi

json_dir="coin_json"

mkdir "$json_dir"
for markdown_file in lib/*.md
do
  json_file=$(basename $markdown_file | sed -e 's/.md/.json/')
  bin/jsonify.sh "$markdown_file" > "$json_dir/$json_file"
done
aws s3 sync "./$json_dir" "s3://$bucket_name" --delete
