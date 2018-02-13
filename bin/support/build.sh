#!/bin/bash

domain="$1" # this is used for hyperlinking content to other content 
project_root="$(pwd)"
build_dir_basename="build"
mkdir -p "$build_dir_basename/coins"
mkdir -p "$build_dir_basename/glossary"

markdown_files="$(ls lib/coins/*.md) $(ls lib/glossary/*.md)"
for markdown_file in $markdown_files 
do
  output_file="$build_dir_basename/$(echo "$markdown_file" | sed -e 's/lib\///' -e 's/\.md/\.json/')"
  bin/support/jsonify.rb "$markdown_file" > "$output_file"
done

json_files="$(ls $build_dir_basename/coins/*.json) $(ls $build_dir_basename/glossary/*.json)"
link_dictionary="$(bin/support/link_dictionary.rb $json_files)" 
for json_file in $json_files
do
  echo "Transforming $json_file..."
  # You can't simulataneously read from and write to a file, hence the use of two separate lines for these transformations
  transformation="$(bin/support/hyperlink.rb "$json_file" "$link_dictionary" "$domain")"
  echo "$transformation" > "$json_file"

  transformation="$(bin/support/htmlify.rb "$json_file")"
  echo "$transformation" > "$json_file"
done
