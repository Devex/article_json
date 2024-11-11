describe ArticleJSON::Import::GoogleDoc::HTML::ParagraphParser do
  subject(:element) do
    described_class.new(node: nokogiri_node, css_analyzer: css_analyzer)
  end

  let(:nokogiri_node) do
    Nokogiri::HTML.fragment(xml_fragment.strip).children.first
  end
  let(:css_analyzer) do
    ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new('')
  end
  let(:xml_fragment) { '<p><span>foo</span><span>bar</span></p>' }

  describe '#content' do
    subject { element.content }

    it 'returns a list of text elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 2

      expect(subject).to all be_a ArticleJSON::Elements::Text

      expect(subject[0].content).to eq 'foo'
      expect(subject[1].content).to eq 'bar'
    end
  end

  describe '#element' do
    subject { element.element }

    it 'returns a proper Hash' do
      expect(subject).to be_a ArticleJSON::Elements::Paragraph
      expect(subject.type).to eq :paragraph
      expect(subject.content).to be_an Array
      expect(subject.content).to all be_a ArticleJSON::Elements::Text
    end
  end
end
