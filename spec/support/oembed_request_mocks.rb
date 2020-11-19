module OembedRequestStubs
  def stub_oembed_requests(additional_headers = {}, custom_body: nil,
                           error: false)
    stub_oembed_facebook_request(additional_headers,
                                 custom_body: custom_body,
                                 error: error)
    stub_oembed_vimeo_request(additional_headers,
                              custom_body: custom_body,
                              error: error)
    stub_oembed_youtube_request(additional_headers,
                                custom_body: custom_body,
                                error: error)
    stub_oembed_slideshare_request(additional_headers,
                                   custom_body: custom_body,
                                   error: error)
    stub_oembed_tweet_request(additional_headers,
                              custom_body: custom_body,
                              error: error)
    stub_oembed_soundcloud_request(additional_headers,
                              custom_body: custom_body,
                              error: error)
  end

  def stub_oembed_facebook_request(additional_headers = {}, custom_body: nil,
                                   error: false)
    stub_oembed_request(
      'https://graph.facebook.com/v9.0/oembed_video?url=https://www.facebook.com/facebook/videos/1814600831891266&access_token=fake_facebook_token',
      custom_body || File.read('spec/fixtures/facebook_video_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_vimeo_request(additional_headers = {}, custom_body: nil,
                                error: false)
    stub_oembed_request(
      'https://vimeo.com/api/oembed.json?url=https://vimeo.com/42315417',
      custom_body || File.read('spec/fixtures/vimeo_video_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_youtube_request(additional_headers = {}, custom_body: nil,
                                  error: false)
    stub_oembed_request(
      'http://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=_ZG8HBuDjgc',
      custom_body || File.read('spec/fixtures/youtube_video_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_slideshare_request(additional_headers = {}, custom_body: nil,
                                     error: false)
    stub_oembed_request(
      'https://www.slideshare.net/api/oembed/2?format=json&url=https://www.slideshare.net/Devex/the-best-global-development-quotes-of-2012',
      custom_body || File.read('spec/fixtures/slideshare_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_tweet_request(additional_headers = {}, custom_body: nil,
                                error: false)
    stub_oembed_request(
      'https://api.twitter.com/1/statuses/oembed.json?align=center&url=https://twitter.com/d3v3x/status/554608639030599681',
      custom_body || File.read('spec/fixtures/tweet_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_soundcloud_request(additional_headers = {}, custom_body: nil,
                                error: false)
    stub_oembed_request(
      'https://soundcloud.com/oembed?url=https://soundcloud.com/rich-the-kid/plug-walk-1&format=json',
      custom_body || File.read('spec/fixtures/soundcloud_oembed.json'),
      additional_headers,
      error: error
    )
  end

  def stub_oembed_request(url, body, additional_headers, custom_body: nil,
                          error: false)
    headers = { 'Content-Type' => 'application/json' }.merge(additional_headers)
    stub = stub_request(:get, url).with(headers: headers)
    if error
      stub.to_return(status: 400, body: 'Unavailable')
    else
      stub.to_return(status: 200, body: body)
    end
  end
end
