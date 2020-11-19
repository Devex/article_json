#!/usr/bin/env sh

curl -X GET "https://vimeo.com/api/oembed.json?url=https://vimeo.com/42315417" | jq > spec/fixtures/vimeo_video_oembed.json

curl -X GET "http://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=_ZG8HBuDjgc" | jq > spec/fixtures/youtube_video_oembed.json

curl -X GET "https://www.slideshare.net/api/oembed/2?format=json&url=https://www.slideshare.net/Devex/the-best-global-development-quotes-of-2012" |  jq > spec/fixtures/slideshare_oembed.json

curl -X GET "https://api.twitter.com/1/statuses/oembed.json?align=center&url=https://twitter.com/d3v3x/status/554608639030599681" | jq > spec/fixtures/tweet_oembed.json

curl -X GET 'https://soundcloud.com/oembed?format=json&url=https://soundcloud.com/rich-the-kid/plug-walk-1' | jq > spec/fixtures/soundcloud_oembed.json
