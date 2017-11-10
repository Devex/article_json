describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedParser do
  subject(:parser) do
    described_class.new(
      node: node,
      caption_node: caption_node,
      css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
    )
  end

  let(:node) { Nokogiri::HTML.fragment(html.strip) }
  let(:html) { "<p><span><a href=\"#{url}\">#{url}</a></span></p>" }
  let(:url) { 'https://www.devex.com' }

  let(:caption_node) { Nokogiri::HTML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }

  describe '#embed_type' do
    it 'is not implemented' do
      expect { parser.embed_type }.to raise_error NotImplementedError
    end
  end

  describe '#.tags' do
    subject { parser.tags }

    context 'when there are tags' do
      let(:html) do
        <<-html
          <p>
            <span>
              <a href="foo">foo</a><span>&nbsp;[foo bar]</span>
            </span>
          </p>
        html
      end
      it { should match_array %w(foo bar) }
    end

    context 'when there are no tags' do
      it { should match_array [] }
    end
  end

  describe '#caption' do
    subject { parser.caption }

    it 'returns a list of text elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 1
      expect(subject).to all be_a ArticleJSON::Elements::Text
      expect(subject.first.content).to eq 'Caption'
    end

    context 'when the caption nil' do
      let(:caption_node) { nil }
      it 'returns a list with one empty text element' do
        expect(subject).to be_an Array
        expect(subject).to be_empty
      end
    end
  end

  describe '.url_regexp' do
    it 'is not implemented' do
      expect { described_class.url_regexp }.to raise_error NotImplementedError
    end
  end

  describe '.build' do
    subject do
      described_class.build(
        node: node,
        caption_node: caption_node,
        css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
      )
    end

    context 'when the node is an embedded vimeo video' do
      let(:url) { 'https://vimeo.com/123' }
      it { should be_a ArticleJSON::Elements::Embed }
    end

    context 'when the node is an embedded youtube video' do
      let(:url) { 'https://www.youtube.com/?v=_ZG8HBuDjgc' }
      it { should be_a ArticleJSON::Elements::Embed }
    end

    context 'when the node is an embedded facebook video' do
      let(:url) { 'https://www.facebook.com/Devex/videos/1814600831891266' }
      it { should be_a ArticleJSON::Elements::Embed }
    end

    context 'when the node is an embedded slideshare' do
      let(:url) { 'https://slideshare.net/Foo/bar-baz' }
      it { should be_a ArticleJSON::Elements::Embed }
    end

    context 'when the node is an embedded tweet' do
      let(:url) { 'twitter.com/d3v3x/status/55460863903059968' }
      it { should be_a ArticleJSON::Elements::Embed }
    end

    context 'when the node is not an embedded element' do
      it { should be nil }
    end
  end

  describe '.supported?' do
    subject { described_class.supported?(node) }

    context 'when the node is an embedded vimeo video' do
      let(:url) { 'https://vimeo.com/123' }
      it { should be true }
    end

    context 'when the node is an embedded youtube video' do
      let(:url) { 'https://www.youtube.com/?v=_ZG8HBuDjgc' }
      it { should be true }
    end

    context 'when the node is an embedded facebook video' do
      let(:url) { 'https://www.facebook.com/Devex/videos/1814600831891266' }
      it { should be true }
    end

    context 'when the node is an embedded slideshare' do
      let(:url) { 'https://slideshare.net/Foo/bar-baz' }
      it { should be true }
    end

    context 'when the node is an embedded tweet' do
      let(:url) { 'twitter.com/d3v3x/status/55460863903059968' }
      it { should be true }
    end

    context 'when the node is not an embedded element' do
      it { should be false }
    end
  end
end
