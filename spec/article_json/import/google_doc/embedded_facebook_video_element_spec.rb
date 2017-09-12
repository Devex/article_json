describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedFacebookVideoElement do
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
          <a href="https://www.facebook.com/Devex/videos/#{video_id}">
            https://www.facebook.com/Devex/videos/#{video_id}
          </a>
          <span>&nbsp;[facebook test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }

  let(:video_id) { '1814600831891266' }
  let(:url_examples) do
    %W(
      https://www.facebook.com/Devex/videos/#{video_id}/
      https://www.facebook.com/video.php?id=#{video_id}
      https://www.facebook.com/video.php?v=#{video_id}
      https://facebook.com/Devex/videos/#{video_id}/
      https://facebook.com/video.php?id=#{video_id}
      https://facebook.com/video.php?v=#{video_id}
      http://www.facebook.com/Devex/videos/#{video_id}/
      http://www.facebook.com/video.php?id=#{video_id}
      http://www.facebook.com/video.php?v=#{video_id}
      http://facebook.com/Devex/videos/#{video_id}/
      http://facebook.com/video.php?id=#{video_id}
      http://facebook.com/video.php?v=#{video_id}
      www.facebook.com/Devex/videos/#{video_id}/
      www.facebook.com/video.php?id=#{video_id}
      www.facebook.com/video.php?v=#{video_id}
      facebook.com/Devex/videos/#{video_id}/
      facebook.com/video.php?id=#{video_id}
      facebook.com/video.php?v=#{video_id}
    )
  end

  describe '#embed_type' do
    subject { element.embed_type }
    it { should eq :facebook_video }
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
      expect(subject[:embed_type]).to eq :facebook_video
      expect(subject[:embed_id]).to eq video_id
      expect(subject[:tags]).to match_array %w(facebook test)
      expect(subject[:caption].first[:content]).to eq 'Caption'
    end
  end

  describe '.matches?' do
    subject { described_class.matches?(url) }

    context 'when passed a text containing a Facebook video URL' do
      let(:url) { url_examples.sample }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      let(:url) { 'https://www.devex.com/news/facebook-videos-hoho-123' }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }

    it { should be_a Regexp }
    it 'matches a lot of different Facebook video URLs' do
      url_examples.each { |url| expect(subject).to match url }
    end
  end
end
