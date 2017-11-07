require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::Slideshare do
  include_context 'for a successful oembed resolution' do
    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :slideshare,
        embed_id: 'Devex/the-best-global-development-quotes-of-2012',
        caption: []
      )
    end
    let(:expected_oembed_url) do
      'https://www.slideshare.net/api/oembed/2?format=json&url='\
        'https://www.slideshare.net/Devex/the-best-global-development-quotes-of-2012'
    end
    let(:oembed_response) { File.read('spec/fixtures/slideshare_oembed.json') }
    let(:expected_name) { 'Slideshare deck' }
  end
end
