require_relative 'embed_parser_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedSoundcloudParser do
  include_context 'for an embed parser' do
    let(:expected_embed_type) { :soundcloud }
    let(:expected_embed_id) { 'rich-the-kid/plug-walk-1' }
    let(:expected_tags) { %w(vimeo test) }
    let(:invalid_url_example) { 'https://soundcloud.xxx/' }
    let(:url_examples) do
      %W(
        https://soundcloud.com/#{expected_embed_id}
      )
    end
  end
end
