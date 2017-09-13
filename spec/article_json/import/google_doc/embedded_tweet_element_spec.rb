require_relative 'embedded_element_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedTweetElement do
  include_context 'for an embeddable object' do
    let(:twitter_handle) { 'd3v3x' }
    let(:tweet_id) { '55460863903059968' }

    let(:expected_embed_type) { :tweet }
    let(:expected_embed_id) { "#{twitter_handle}/#{tweet_id}" }
    let(:expected_tags) { %w(twitter test) }
    let(:invalid_url_example) { 'https://www.devex.com/twitter-fun-123' }
    let(:url_examples) do
      %W(
        twitter.com/#{twitter_handle}/status/#{tweet_id}
        http://twitter.com/#{twitter_handle}/status/#{tweet_id}
        https://twitter.com/#{twitter_handle}/status/#{tweet_id}
        www.twitter.com/#{twitter_handle}/status/#{tweet_id}
        http://www.twitter.com/#{twitter_handle}/status/#{tweet_id}
        https://www.twitter.com/#{twitter_handle}/status/#{tweet_id}

        twitter.com/#{twitter_handle}/statuses/#{tweet_id}
        http://twitter.com/#{twitter_handle}/statuses/#{tweet_id}
        https://twitter.com/#{twitter_handle}/statuses/#{tweet_id}
        www.twitter.com/#{twitter_handle}/statuses/#{tweet_id}
        http://www.twitter.com/#{twitter_handle}/statuses/#{tweet_id}
        https://www.twitter.com/#{twitter_handle}/statuses/#{tweet_id}

        twitter.com/#{twitter_handle}##{tweet_id}
        http://twitter.com/#{twitter_handle}##{tweet_id}
        https://twitter.com/#{twitter_handle}##{tweet_id}
        www.twitter.com/#{twitter_handle}##{tweet_id}
        http://www.twitter.com/#{twitter_handle}##{tweet_id}
        https://www.twitter.com/#{twitter_handle}##{tweet_id}
      )
    end
  end
end
