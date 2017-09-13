require_relative 'embedded_element_shared'

describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedYoutubeVideoElement do
  include_context 'for an embeddable object' do
    let(:expected_embed_type) { :youtube_video }
    let(:expected_embed_id) { '_ZG8HBuDjgc' }
    let(:expected_tags) { %w(youtube test) }
    let(:invalid_url_example) { 'https://www.devex.com/news/youtube-video-123' }
    let(:url_examples) do
      %W(
        http://youtu.be/#{expected_embed_id}?hl=en_US
        http://www.youtube.com/embed/#{expected_embed_id}
        http://www.youtube.com/watch?v=#{expected_embed_id}&hl=en_US
        http://www.youtube.com/?v=#{expected_embed_id}
        http://www.youtube.com/v/#{expected_embed_id}
        http://www.youtube.com/e/#{expected_embed_id}
        http://www.youtube.com/user/username#p/u/11/#{expected_embed_id}
        http://www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{expected_embed_id}
        http://www.youtube.com/watch?feature=player_embedded&v=#{expected_embed_id}&hl=en_US
        http://www.youtube.com/?feature=player_embedded&v=#{expected_embed_id}
        https://youtu.be/#{expected_embed_id}?hl=en_US
        https://www.youtube.com/embed/#{expected_embed_id}
        https://www.youtube.com/watch?v=#{expected_embed_id}&hl=en_US
        https://www.youtube.com/?v=#{expected_embed_id}
        https://www.youtube.com/v/#{expected_embed_id}
        https://www.youtube.com/e/#{expected_embed_id}
        https://www.youtube.com/user/username#p/u/11/#{expected_embed_id}
        https://www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{expected_embed_id}
        https://www.youtube.com/watch?feature=player_embedded&v=#{expected_embed_id}
        https://www.youtube.com/?feature=player_embedded&v=#{expected_embed_id}
        youtu.be/#{expected_embed_id}?hl=en_US
        www.youtube.com/embed/#{expected_embed_id}
        www.youtube.com/watch?v=#{expected_embed_id}&hl=en_US
        www.youtube.com/?v=#{expected_embed_id}
        www.youtube.com/v/#{expected_embed_id}
        www.youtube.com/e/#{expected_embed_id}
        www.youtube.com/user/username#p/u/11/#{expected_embed_id}
        www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{expected_embed_id}
        www.youtube.com/watch?feature=player_embedded&v=#{expected_embed_id}
        www.youtube.com/?feature=player_embedded&v=#{expected_embed_id}
        youtube.com/embed/#{expected_embed_id}
        youtube.com/watch?v=#{expected_embed_id}&hl=en_US
        youtube.com/?v=#{expected_embed_id}
        youtube.com/v/#{expected_embed_id}
        youtube.com/e/#{expected_embed_id}
        youtube.com/user/username#p/u/11/#{expected_embed_id}
        youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{expected_embed_id}
        youtube.com/watch?feature=player_embedded&v=#{expected_embed_id}
        youtube.com/?feature=player_embedded&v=#{expected_embed_id}
      )
    end
  end
end
