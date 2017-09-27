module OembedRequestStubs
  def stub_oembed_requests(additional_headers = {})
    stub_oembed_facebook_request(additional_headers)
    stub_oembed_vimeo_request(additional_headers)
    stub_oembed_youtube_request(additional_headers)
    stub_oembed_slideshare_request(additional_headers)
    stub_oembed_tweet_request(additional_headers)
  end

  def stub_oembed_facebook_request(additional_headers = {})
    stub_oembed_request(
      'https://www.facebook.com/plugins/video/oembed.json?url=facebook.com/facebook/videos/1814600831891266',
      'facebook_video_oembed',
      additional_headers
    )
  end

  def stub_oembed_vimeo_request(additional_headers = {})
    stub_oembed_request(
      'https://vimeo.com/api/oembed.json?url=https://vimeo.com/42315417',
      'vimeo_video_oembed',
      additional_headers
    )
  end

  def stub_oembed_youtube_request(additional_headers = {})
    stub_oembed_request(
      'http://www.youtube.com/oembed?format=json&url=youtube.com/watch?v=_ZG8HBuDjgc',
      'youtube_video_oembed',
      additional_headers
    )
  end

  def stub_oembed_slideshare_request(additional_headers = {})
    stub_oembed_request(
      'https://www.slideshare.net/api/oembed/2?format=json&url=www.slideshare.net/Devex/the-best-global-development-quotes-of-2012',
      'slideshare_oembed',
      additional_headers
    )
  end

  def stub_oembed_tweet_request(additional_headers = {})
    stub_oembed_request(
      'https://api.twitter.com/1/statuses/oembed.json?align=center&url=https://twitter.com/d3v3x/status/554608639030599681',
      'tweet_oembed',
      additional_headers
    )
  end

  def stub_oembed_request(url, fixture, additional_headers)
    headers = { 'Content-Type' => 'application/json' }.merge(additional_headers)
    stub_request(:get, url)
      .with(headers: headers)
      .to_return(
        body: File.read("spec/fixtures/#{fixture}.json")
      )
  end
end
