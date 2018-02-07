#!/bin/bash

domain="$1"
link_dictionary="$(printf "$(bin/support/link_dictionary.sh)")"

pwd

ruby bin/support/jsonify.rb lib/coins/btc.md > btc.json
ruby bin/support/hyperlink.rb btc.json "$link_dictionary" "https://xyz.com" 