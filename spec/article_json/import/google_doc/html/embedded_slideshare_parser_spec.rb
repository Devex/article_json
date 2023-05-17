require_relative 'embed_parser_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedSlideshareParser do
  include_context 'for an embed parser' do
    let(:slideshare_handle) { 'Devex' }
    let(:slide_id) { 'the-best-global-development-quotes-of-2012' }

    let(:expected_embed_type) { :slideshare }
    let(:expected_embed_id) { "#{slideshare_handle}/#{slide_id}" }
    let(:expected_tags) { %w[slideshare test] }
    let(:invalid_url_example) { 'https://www.devex.com/news/slideshare-123' }
    let(:url_examples) do
      %W[
        slideshare.net/#{slideshare_handle}/#{slide_id}
        http://slideshare.net/#{slideshare_handle}/#{slide_id}
        https://slideshare.net/#{slideshare_handle}/#{slide_id}
        www.slideshare.net/#{slideshare_handle}/#{slide_id}
        http://www.slideshare.net/#{slideshare_handle}/#{slide_id}
        https://www.slideshare.net/#{slideshare_handle}/#{slide_id}
      ]
    end
  end
end
