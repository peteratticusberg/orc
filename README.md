Descriptions of alt coins. 

Currently I'm thinking we can store all the research we've done in this repo as markdown files with standardized headers. So long as we keep things standardized, it should be easy to parse data out of these files and display in some other medium. 

This is all still very a much a work in progress, but at least initially I'm thinking we can use the headers

`## Overview` - an explanation of what the coin is meant to be used for

`## Roadmap` - a description of desired end state for the coin and what's been done to date to move it towards that state 

`## Team` - an overview of the people and organizations involved with the coin

`## Technology` - an optional section on anything noteworthy about the technology behind the coin

`## Website` - a link to the website for the coin

`## Ticker`- The ticker sym for a coin (BTC, ETH, XRB, etc.)

`## Coin Market Cap key` - coinmarketcap.com has a string it uses to identify each coin independent of its ticker. E.g. for BAT the string is "basic-attention-token". You can find these strings by just looking at the url e.g. https://coinmarketcap.com/currencies/basic-attention-token/. I don't know if the coinmarketcap API is the best one around for price data but figure it couldn't hurt to track this for now.

`## Tags` - a comma delimited list of tags that apply to the coin
