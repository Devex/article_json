require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::VimeoVideo do
  include_context 'for a successful oembed resolution' do
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :vimeo_video,
        embed_id: 42315417,
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'https://vimeo.com/api/oembed.json?url=https://vimeo.com/42315417'
    end
    let(:oembed_response) { File.read('spec/fixtures/vimeo_video_oembed.json') }
    let(:expected_name) { 'Vimeo video' }
  end
end
