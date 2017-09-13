describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedSlideshareElement do
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
          <a href="https://www.slideshare.net/Devex/#{slide_id}">
            https://www.slideshare.net/Devex/#{slide_id}
          </a>
          <span>&nbsp;[slideshare test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }
  let(:slide_id) { 'the-best-global-development-quotes-of-2012' }
  let(:url_examples) do
    %W(
      slideshare.net/Devex/#{slide_id}
      http://slideshare.net/Devex/#{slide_id}
      https://slideshare.net/Devex/#{slide_id}
      www.slideshare.net/Devex/#{slide_id}
      http://www.slideshare.net/Devex/#{slide_id}
      https://www.slideshare.net/Devex/#{slide_id}
    )
  end

  describe '#embed_type' do
    subject { element.embed_type }
    it { should eq :slideshare }
  end

  describe '#embed_id' do
    subject { element.embed_id }
    it { should eq "Devex/#{slide_id}" }
  end

  describe 'to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :embed
      expect(subject[:embed_type]).to eq :slideshare
      expect(subject[:embed_id]).to eq "Devex/#{slide_id}"
      expect(subject[:tags]).to match_array %w(slideshare test)
      expect(subject[:caption].first[:content]).to eq 'Caption'
    end
  end

  describe '.matches?' do
    subject { described_class.matches?(url) }

    context 'when passed a text containing a Slideshare URL' do
      let(:url) { url_examples.sample }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      let(:url) { 'https://www.devex.com/news/slideshare-deck-123' }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }

    it { should be_a Regexp }
    it 'matches a lot of different slideshare URLs' do
      url_examples.each { |url| expect(subject).to match url }
    end
  end
end
