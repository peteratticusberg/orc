#!/bin/bash

# Things got out of hand here, this definitely needs to be rewritten in ruby

function update_dictionary() {
  dictionary="$1"
  markdown_file="$2"
  header="## $3"
  file_basename="$(basename "$markdown_file" | sed -e s/.md//)"
  section_values="$(grep -A 2 "$header" "$markdown_file" | tail -n 1 | tr ',' '\n')"
  while read -r section_value; do
    entry_value="\"$section_value\": \"/coins/$file_basename\","  
    dictionary="$dictionary\n  $entry_value"  
  done < <(echo "$section_values")  
  printf "%s" "$dictionary"
}

dictionary=""

for coin_file in lib/coins/*.md
do
  dictionary="$(update_dictionary "$dictionary" "$coin_file" "Coin Name")"
  dictionary="$(update_dictionary "$dictionary" "$coin_file" "Preferred Ticker")"
done

for glossary_file in lib/glossary/*.md
do
  dictionary="$(update_dictionary "$dictionary" "$glossary_file" "Hyperlink Values")"
done

dictionary="$(printf "%s" "$dictionary" | sed '$ s/,$//')" # remove trailing comma
dictionary="{$dictionary\n}\n" # format as json

printf "%s" "$dictionary"
