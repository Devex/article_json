require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::Tweet do
  include_context 'for a successful oembed resolution' do
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :tweet,
        embed_id: 'd3v3x/554608639030599681',
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'https://api.twitter.com/1/statuses/oembed.json?align=center&url=' \
        'https://twitter.com/d3v3x/status/554608639030599681'
    end
    let(:oembed_response) do
      File.read('spec/fixtures/tweet_oembed.json')
    end
    let(:expected_name) { 'Tweet' }
  end
end
