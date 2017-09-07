describe ArticleJSON::Import::GoogleDoc::HTML::TextElement do
  subject(:element) do
    described_class.new(text_node: nokogiri_node, css_analyzer: css_analyzer)
  end
  let(:nokogiri_node) do
    Nokogiri::XML.fragment(xml_fragment.strip).children.first
  end
  let(:css_analyzer) do
    ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new(
      <<-css
        .bold { font-weight: bold }
        .italic { font-style: italic }
        .bold-italic { font-weight: bold; font-style: italic }
      css
    )
  end

  describe '#content' do
    subject { element.content }
    let(:xml_fragment) { '<span>foo bar</span>' }
    it { should eq 'foo bar' }
  end

  describe '#bold?' do
    subject { element.bold? }

    context 'when the node has a bold class attribute only' do
      let(:xml_fragment) { '<span class="bold">foo bar</span>' }
      it { should be true }
    end

    context 'when the node has a bold & italic class attribute' do
      let(:xml_fragment) { '<span class="bold-italic">foo bar</span>' }
      it { should be true }
    end

    context 'when the node has a non-bold class attribute' do
      let(:xml_fragment) { '<span class="italic">foo bar</span>' }
      it { should be false }
    end

    context 'when the node has no class attribute' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it { should be false }
    end
  end

  describe '#italic?' do
    subject { element.italic? }

    context 'when the node has a italic class attribute only' do
      let(:xml_fragment) { '<span class="italic">foo bar</span>' }
      it { should be true }
    end

    context 'when the node has a bold & italic class attribute' do
      let(:xml_fragment) { '<span class="bold-italic">foo bar</span>' }
      it { should be true }
    end

    context 'when the node has a non-italic class attribute' do
      let(:xml_fragment) { '<span class="bold">foo bar</span>' }
      it { should be false }
    end

    context 'when the node has no class attribute' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it { should be false }
    end
  end

  describe '#href' do
    subject { element.href }

    context 'when the text includes no link' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it { should be nil }
    end

    context 'when the text includes a simple link' do
      let(:xml_fragment) do
        <<-html
          <span><a href="https://devex.com">foo bar</a></span>
        html
      end
      it { should eq 'https://devex.com' }
    end

    context 'when the text includes a link with a google redirect' do
      let(:xml_fragment) do
        <<-html
          <span><a href="https://www.google.com/url?q=https://devex.com">foo bar</a></span>
        html
      end
      it { should eq 'https://devex.com' }
    end
  end

  describe 'to_h' do
    subject { element.to_h }

    context 'when having a simple text' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it 'returns a proper Hash' do
        expect(subject).to be_a Hash
        expect(subject[:type]).to eq :text
        expect(subject[:content]).to eq 'foo bar'
        expect(subject[:bold]).to be false
        expect(subject[:italic]).to be false
        expect(subject[:href]).to be nil
      end
    end

    context 'when having a styles text and a link' do
      let(:xml_fragment) do
        <<-html
          <span class="bold-italic"><a href="https://devex.com">foo bar</a></span>
        html
      end
      it 'returns a proper Hash' do
        expect(subject).to be_a Hash
        expect(subject[:type]).to eq :text
        expect(subject[:content]).to eq 'foo bar'
        expect(subject[:bold]).to be true
        expect(subject[:italic]).to be true
        expect(subject[:href]).to eq 'https://devex.com'
      end
    end
  end

  describe '.extract' do
    subject do
      described_class.extract(text_node: nokogiri_node,
                              css_analyzer: css_analyzer)
    end

    let(:xml_fragment) do
      <<-html
        <p><span class="bold">A </span><span><a href="https://devex.com">link</a></span><span class="italic"> and styling.</span></p>
      html
    end

    it 'parses all text sub-nodes' do
      expect(subject.size).to eq 3

      expect(subject[0].content).to eq 'A '
      expect(subject[0].bold?).to be true
      expect(subject[0].italic?).to be false
      expect(subject[0].href).to be nil

      expect(subject[1].content).to eq 'link'
      expect(subject[1].bold?).to be false
      expect(subject[1].italic?).to be false
      expect(subject[1].href).to eq 'https://devex.com'

      expect(subject[2].content).to eq ' and styling.'
      expect(subject[2].bold?).to be false
      expect(subject[2].italic?).to be true
      expect(subject[2].href).to be nil
    end
  end
end
