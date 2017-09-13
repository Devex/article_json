require_relative 'embedded_element_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedVimeoVideoElement do
  include_context 'for an embeddable object' do
    let(:expected_embed_type) { :vimeo_video }
    let(:expected_embed_id) { '123' }
    let(:expected_tags) { %w(vimeo test) }
    let(:invalid_url_example) { 'https://www.devex.com/news/facebook-video-12' }
    let(:url_examples) do
      %W(
        https://www.vimeo.com/#{expected_embed_id}?foo=bar
        http://www.vimeo.com/#{expected_embed_id}?foo=bar
        www.vimeo.com/#{expected_embed_id}?foo=bar
        https://vimeo.com/#{expected_embed_id}?foo=bar
        http://vimeo.com/#{expected_embed_id}?foo=bar
        vimeo.com/#{expected_embed_id}?foo=bar
      )
    end
  end
end
