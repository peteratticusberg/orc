#!/bin/bash

echo "uploading to s3..."

bucket_name="$1"
domain="$2" # this is used by the build script to hyperlink content to other content 
aws_profile="" # can be used to specify a non-default profile for the aws cli from the .aws/credentials file
if [ -n "$3" ]; then 
  aws_profile="$3"
fi

bin/support/build.sh "$domain"

is_aws_installed="$(which aws)"
if [ -z "$is_aws_installed" ]; then
  error_msg="ERROR: The aws cli must be installed to run this command. For installation instructions see https://docs.aws.amazon.com/cli/latest/userguide/installing.html"
  echo -e "\033[0;31m$error_msg\033[0m"
  exit 1
fi

if [ -z "$bucket_name" ]; then
  error_msg="ERROR: No bucket name specified. To specify a bucket name, pass it as the first argument to this command, e.g. \`bin/upload.sh my-bucket-name\`"
  echo -e "\033[0;31m$error_msg\033[0m"
  exit 1
fi

build_dir="$(pwd)/build"
aws s3 sync "$build_dir" "s3://$bucket_name" --delete --exclude ".DS_Store" --profile "$aws_profile"
