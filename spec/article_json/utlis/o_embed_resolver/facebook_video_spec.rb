require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::FacebookVideo do
  include_context 'for a successful oembed resolution' do
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :facebook_video,
        embed_id: 1814600831891266,
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'https://www.facebook.com/plugins/video/oembed.json?url=' \
        'facebook.com/facebook/videos/1814600831891266'
    end
    let(:oembed_response) do
      File.read('spec/fixtures/facebook_video_oembed.json')
    end
  end
end
