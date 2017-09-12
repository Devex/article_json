describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedVimeoVideoElement do
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
          <a href="https://vimeo.com/123">https://vimeo.com/123</a>
          <span>&nbsp;[vimeo test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }

  describe '#embed_type' do
    subject { element.embed_type }
    it { should eq :vimeo_video }
  end

  describe '#embed_id' do
    subject { element.embed_id }
    it { should eq '123' }
  end

  describe 'to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :embed
      expect(subject[:embed_type]).to eq :vimeo_video
      expect(subject[:embed_id]).to eq '123'
      expect(subject[:tags]).to match_array %w(vimeo test)
      expect(subject[:caption].first[:content]).to eq 'Caption'
    end
  end

  describe '.matches?' do
    subject { described_class.matches?(url) }

    context 'when passed a text containing a vimeo URL' do
      let(:url) { 'https://vimeo.com/123' }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      let(:url) { 'https://www.devex.com/news/vimeo-videos-rock-123' }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }
    it { should be_a Regexp }
    it { should match 'https://vimeo.com/123' }
  end
end
