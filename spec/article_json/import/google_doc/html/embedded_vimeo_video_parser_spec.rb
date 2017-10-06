require_relative 'embed_parser_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedVimeoVideoParser do
  include_context 'for an embed parser' do
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
        https://vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=bar
        http://vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=bar
        vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=bar
        https://www.vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=bar
        http://www.vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=bar
        www.vimeo.com/moogaloop.swf?clip_id=#{expected_embed_id}&foo=012
      )
    end
  end
end
