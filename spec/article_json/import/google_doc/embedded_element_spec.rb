describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedElement do
  subject(:element) do
    described_class.new(
      node: node,
      caption_node: caption_node,
      css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
    )
  end

  let(:node) { Nokogiri::XML.fragment(html.strip) }
  let(:html) { '' }
  let(:vimeo_video_html) do
    <<-html
      <p>
        <span>
          <a href="https://vimeo.com/123">https://vimeo.com/123</a>
          <span>&nbsp;[vimeo test]</span>
        </span>
      </p>
    html
  end
  let(:youtube_video_html) do
    <<-html
      <p>
        <span>
          <a href="https://www.youtube.com/?v=_ZG8HBuDjgc">
            https://www.youtube.com/?v=_ZG8HBuDjgc
          </a>
          <span>&nbsp;[youtube test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }

  describe '#embed_type' do
    it 'is not implemented' do
      expect { element.embed_type }.to raise_error NotImplementedError
    end
  end

  describe '#.tags' do
    subject { element.tags }

    context 'when there are tags' do
      let(:html) { vimeo_video_html }
      it { should match_array %w(vimeo test) }
    end

    context 'when there are no tags' do
      it { should match_array [] }
    end
  end

  describe '#caption' do
    subject { element.caption }

    it 'returns a list of text elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 1

      expect(subject)
        .to all be_a ArticleJSON::Import::GoogleDoc::HTML::TextElement

      expect(subject.first.content).to eq 'Caption'
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

    context 'when the node is not an embedded element' do
      it { should be nil }
    end

    context 'when the node is an embedded vimeo video' do
      let(:html) { vimeo_video_html }
      let(:expected_class) do
        ArticleJSON::Import::GoogleDoc::HTML::EmbeddedVimeoVideoElement
      end
      it { should be_a expected_class }
    end

    context 'when the node is an embedded youtube video' do
      let(:html) { youtube_video_html }
      let(:expected_class) do
        ArticleJSON::Import::GoogleDoc::HTML::EmbeddedYoutubeVideoElement
      end
      it { should be_a expected_class }
    end
  end

  describe '.supported?' do
    subject { described_class.supported?(node) }

    context 'when the node is an embedded vimeo video' do
      let(:html) { vimeo_video_html }
      it { should be true }
    end

    context 'when the node is an embedded youtube video' do
      let(:html) { youtube_video_html }
      it { should be true }
    end

    context 'when the node is not an embedded element' do
      let(:html) do
        <<-html
          <p>
            <span>
              <a href="https://www.devex.com">https://www.devex.com</a>
              <span>&nbsp;[devex]</span>
            </span>
          </p>
        html
      end
      it { should be false }
    end
  end
end
