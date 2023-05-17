require_relative 'embed_parser_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedFacebookVideoParser do
  include_context 'for an embed parser' do
    let(:expected_embed_type) { :facebook_video }
    let(:expected_embed_id) { '1814600831891266' }
    let(:expected_tags) { %w[facebook test] }
    let(:invalid_url_example) { 'https://www.devex.com/news/facebook-video-12' }
    let(:url_examples) do
      %W[
        https://www.facebook.com/Devex/videos/#{expected_embed_id}/
        https://www.facebook.com/video.php?id=#{expected_embed_id}
        https://www.facebook.com/video.php?v=#{expected_embed_id}
        https://facebook.com/Devex/videos/#{expected_embed_id}/
        https://facebook.com/video.php?id=#{expected_embed_id}
        https://facebook.com/video.php?v=#{expected_embed_id}
        http://www.facebook.com/Devex/videos/#{expected_embed_id}/
        http://www.facebook.com/video.php?id=#{expected_embed_id}
        http://www.facebook.com/video.php?v=#{expected_embed_id}
        http://facebook.com/Devex/videos/#{expected_embed_id}/
        http://facebook.com/video.php?id=#{expected_embed_id}
        http://facebook.com/video.php?v=#{expected_embed_id}
        www.facebook.com/Devex/videos/#{expected_embed_id}/
        www.facebook.com/video.php?id=#{expected_embed_id}
        www.facebook.com/video.php?v=#{expected_embed_id}
        facebook.com/Devex/videos/#{expected_embed_id}/
        facebook.com/video.php?id=#{expected_embed_id}
        facebook.com/video.php?v=#{expected_embed_id}
      ]
    end
  end
end
