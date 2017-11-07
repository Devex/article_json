require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::YoutubeVideo do
  include_context 'for a successful oembed resolution' do
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :vimeo_video,
        embed_id: '_ZG8HBuDjgc',
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'http://www.youtube.com/oembed?format=json&url=' \
        'https://www.youtube.com/watch?v=_ZG8HBuDjgc'
    end
    let(:oembed_response) do
      File.read('spec/fixtures/youtube_video_oembed.json')
    end
    let(:expected_name) { 'Youtube video' }
  end
end
