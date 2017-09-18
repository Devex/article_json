describe ArticleJSON::Import::GoogleDoc::HTML::ListParser do
  subject(:element) do
    described_class.new(node: node, css_analyzer: css_analyzer)
  end

  let(:node) { Nokogiri::HTML.fragment(html.strip).first_element_child }
  let(:html) do
    <<-html
      <#{list_tag}>
        <li><span>foo</span></li>
        <li><span>bar</span></li>
      </#{list_tag}>
    html
  end

  let(:css_analyzer) do
    ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new('')
  end

  describe '#list_type' do
    subject { element.list_type }

    context 'when it is a ordered list' do
      let(:list_tag) { 'ol' }
      it { should be :ordered }
    end

    context 'when it is a unordered list' do
      let(:list_tag) { 'ul' }
      it { should be :unordered }
    end

    context 'when it is an invalid list' do
      let(:list_tag) { 'list' }
      it { should be nil }
    end
  end

  describe '#content' do
    subject { element.content }
    let(:list_tag) { 'ul' }

    it 'returns a list of text elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 2

      expect(subject).to all be_a ArticleJSON::Elements::Paragraph

      expect(subject[0].content.first.content).to eq 'foo'
      expect(subject[1].content.first.content).to eq 'bar'
    end
  end

  describe '#element' do
    subject { element.element }
    let(:list_tag) { 'ol' }

    it 'returns a proper list element' do
      expect(subject).to be_a ArticleJSON::Elements::List
      expect(subject.type).to eq :list
      expect(subject.list_type).to eq :ordered
      expect(subject.content).to be_an Array
      expect(subject.content).to all be_a ArticleJSON::Elements::Paragraph
    end
  end
end
