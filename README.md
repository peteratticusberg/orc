Descriptions of alt coins. 

Currently I'm thinking we can store all the research we've done in this repo as markdown files with standardized headers. So long as we keep things standardized, it should be easy to parse data out of these files and display in some other medium. 

This is all still very a much a work in progress, but at least initially I'm thinking we can use the headers

`## Coin Description` - a description of what the coin is used for (as opposed to how the coin works, which I think should be a separate section)
`## Company History` - a description of what the company has accomplished to date
`## Website` - a link to the website for the coin
`## Team`
`## Tags` - a comma delimited list of tags
`## Coin Market Cap key` - coinmarketcap.com has a string it uses to identify each coin independent of its ticker. E.g. for BAT the string is "basic-attention-token". You can find these strings by just looking at the url e.g. https://coinmarketcap.com/currencies/basic-attention-token/. I don't know if the coinmarketcap API is the best one around for price data but figure it couldn't hurt to track this for now.
`## Ticker`- The ticker sym for a coin (BTC, ETH, XRB, etc.)

