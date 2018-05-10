require_relative 'embed_parser_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedSoundcloudParser do
  include_context 'for an embed parser' do
    let(:expected_embed_type) { :soundcloud }
    let(:expected_embed_id) { 'rich-the-kid/plug-walk-1' }
    let(:expected_tags) { %w(test soundcloud) }
    let(:invalid_url_example) { 'https://soundcloud.xxx/' }
    let(:url_examples) do
      %W(
        https://soundcloud.com/#{expected_embed_id}
        https://soundcloud.com/#{expected_embed_id}\u{a0}
        https://soundcloud.com/#{expected_embed_id}?something=else
      )
    end
  end
end
