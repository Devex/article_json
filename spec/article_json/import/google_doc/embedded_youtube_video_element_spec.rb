describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedYoutubeVideoElement do
  subject(:element) do
    described_class.new(
      node: node,
      caption_node: caption_node,
      css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
    )
  end

  let(:node) { Nokogiri::XML.fragment(html.strip) }
  let(:html) do
    <<-html
      <p>
        <span>
          <a href="https://www.youtube.com/?v=#{video_id}">
            https://www.youtube.com/?v=#{video_id}
          </a>
          <span>&nbsp;[youtube test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }

  let(:video_id) { '_ZG8HBuDjgc' }
  let(:url_examples) do
    %W(
      http://youtu.be/#{video_id}?hl=en_US
      http://www.youtube.com/embed/#{video_id}
      http://www.youtube.com/watch?v=#{video_id}&hl=en_US
      http://www.youtube.com/?v=#{video_id}
      http://www.youtube.com/v/#{video_id}
      http://www.youtube.com/e/#{video_id}
      http://www.youtube.com/user/username#p/u/11/#{video_id}
      http://www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{video_id}
      http://www.youtube.com/watch?feature=player_embedded&v=#{video_id}&hl=en_US
      http://www.youtube.com/?feature=player_embedded&v=#{video_id}
      https://youtu.be/#{video_id}?hl=en_US
      https://www.youtube.com/embed/#{video_id}
      https://www.youtube.com/watch?v=#{video_id}&hl=en_US
      https://www.youtube.com/?v=#{video_id}
      https://www.youtube.com/v/#{video_id}
      https://www.youtube.com/e/#{video_id}
      https://www.youtube.com/user/username#p/u/11/#{video_id}
      https://www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{video_id}
      https://www.youtube.com/watch?feature=player_embedded&v=#{video_id}
      https://www.youtube.com/?feature=player_embedded&v=#{video_id}
      youtu.be/#{video_id}?hl=en_US
      www.youtube.com/embed/#{video_id}
      www.youtube.com/watch?v=#{video_id}&hl=en_US
      www.youtube.com/?v=#{video_id}
      www.youtube.com/v/#{video_id}
      www.youtube.com/e/#{video_id}
      www.youtube.com/user/username#p/u/11/#{video_id}
      www.youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{video_id}
      www.youtube.com/watch?feature=player_embedded&v=#{video_id}
      www.youtube.com/?feature=player_embedded&v=#{video_id}
      youtube.com/embed/#{video_id}
      youtube.com/watch?v=#{video_id}&hl=en_US
      youtube.com/?v=#{video_id}
      youtube.com/v/#{video_id}
      youtube.com/e/#{video_id}
      youtube.com/user/username#p/u/11/#{video_id}
      youtube.com/sandalsResorts#p/c/54B8C800269D7C1B/0/#{video_id}
      youtube.com/watch?feature=player_embedded&v=#{video_id}
      youtube.com/?feature=player_embedded&v=#{video_id}
    )
  end

  describe '#embed_type' do
    subject { element.embed_type }
    it { should eq :youtube_video }
  end

  describe '#embed_id' do
    subject { element.embed_id }
    it { should eq video_id }
  end

  describe 'to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :embed
      expect(subject[:embed_type]).to eq :youtube_video
      expect(subject[:embed_id]).to eq video_id
      expect(subject[:tags]).to match_array %w(youtube test)
      expect(subject[:caption].first[:content]).to eq 'Caption'
    end
  end

  describe '.matches?' do
    subject { described_class.matches?(url) }

    context 'when passed a text containing a Youtube URL' do
      let(:url) { url_examples.sample }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      let(:url) { 'https://www.devex.com/news/youtube-videos-ftw-123' }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }

    it { should be_a Regexp }
    it 'matches a lot of different Youtube URLs' do
      url_examples.each { |url| expect(subject).to match url }
    end
  end
end
