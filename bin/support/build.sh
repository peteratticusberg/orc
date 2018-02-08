#!/bin/bash

domain="$1"
project_root="$(pwd)"
build_dir="$project_root/build"
mkdir -p "$build_dir/coins"
mkdir -p "$build_dir/glossary"

link_dictionary="$(printf "$(bin/support/link_dictionary.sh)")"

function transform() {
  markdown_file="$1"
  parent_dir="$2" # expects coins or glossary
  output_file="$build_dir/$parent_dir/$(basename $markdown_file | sed -e 's/.md/.json/')"
  # You can't read from a file while you're also outputting to it so we have to write to file on a separate line
  transformation="$(ruby bin/support/jsonify.rb "$markdown_file")"
  echo "$transformation" > "$output_file"
  transformation="$(ruby bin/support/hyperlink.rb "$output_file" "$link_dictionary" "$domain")"
  echo "$transformation" > "$output_file"
  transformation="$(bin/support/htmlify.sh "$output_file")"
  echo "$transformation" > "$output_file"
}

for markdown_file in lib/coins/*.md
do
  transform "$(pwd)/$markdown_file" coins
done

for markdown_file in lib/glossary/*.md
do
  transform "$markdown_file" glossary
done
