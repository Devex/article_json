require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::Soundcloud do
  include_context 'for a successful oembed resolution' do
    let(:embed_id) { 'rich-the-kid/plug-walk-1' }
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :soundcloud,
        embed_id: embed_id,
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'https://soundcloud.com/oembed?' \
      "url=https://soundcloud.com/#{embed_id}&format=json"
    end
    let(:oembed_response) do
      File.read('spec/fixtures/soundcloud_oembed.json')
    end
    let(:expected_name) { 'Soundcloud' }
  end
end
