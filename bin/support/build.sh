#!/bin/bash

domain="$1" # this is used for hyperlinking content to other content 
project_root="$(pwd)"
build_dir="$project_root/build"
mkdir -p "$build_dir/coins"
mkdir -p "$build_dir/glossary"

link_dictionary="$(printf "$(bin/support/link_dictionary.sh)")"

function build() {
  markdown_file="$1"
  parent_dir="$2" # expects coins or glossary
  output_file="$build_dir/$parent_dir/$(basename $markdown_file | sed -e 's/.md/.json/')"

  # You can't simulataneously read from and write to a file, hence the use of two separate lines for these transformations
  transformation="$(bin/support/jsonify.rb "$markdown_file")"
  echo "$transformation" > "$output_file"

  transformation="$(bin/support/hyperlink.rb "$output_file" "$link_dictionary" "$domain")"
  echo "$transformation" > "$output_file"

  transformation="$(bin/support/htmlify.rb "$output_file")"
  echo "$transformation" > "$output_file"
}

for markdown_file in lib/coins/*.md
do
  echo "Transforming $markdown_file..."
  build "$(pwd)/$markdown_file" coins
done

for markdown_file in lib/glossary/*.md
do
  echo "Transforming $markdown_file..."
  build "$(pwd)/$markdown_file" glossary
done
