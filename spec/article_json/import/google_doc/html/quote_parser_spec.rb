describe ArticleJSON::Import::GoogleDoc::HTML::QuoteParser do
  subject(:parser) do
    described_class.new(nodes: node.children, css_analyzer: css_analyzer)
  end

  let(:node) { Nokogiri::HTML.fragment(html.strip) }
  let(:html) do
    <<-html
      <p class="css_class"><span>#{quote}</span></p>
      <p class="css_class"><span>#{caption}</span></p>
    html
  end
  let(:quote) { 'Operator! Give me the number for 911!' }
  let(:caption) { 'Homer Simpson' }

  let(:css_analyzer) do
    ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new(css)
  end
  let(:css) { '' }

  describe '#float' do
    subject { parser.float }
    context 'when the first node is centered' do
      let(:css) { '.css_class { text-align: center }' }
      it { should be nil }
    end

    context 'when the first node is right aligned' do
      let(:css) { '.css_class { text-align: right }' }
      it { should be :right }
    end

    context 'when the first node is not aligned' do
      it { should be :left }
    end
  end

  describe '#content' do
    subject { parser.content }

    it 'returns a list of paragraph and heading elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 1

      expect(subject.first).to be_a ArticleJSON::Elements::Paragraph
      expect(subject.first.content.first.content).to eq quote
    end
  end

  describe '#caption' do
    subject { parser.caption }

    context 'if there is a proper caption defined' do
      it 'returns a list of text elements' do
        expect(subject).to be_an Array
        expect(subject.size).to eq 1

        expect(subject).to all be_a ArticleJSON::Elements::Text

        expect(subject.first.content).to eq caption
      end
    end

    context 'if the caption is `[no-caption]`' do
      let(:caption) { '[no-caption]' }
      it 'returns an empty list' do
        expect(subject).to be_an Array
        expect(subject).to be_empty
      end
    end
  end

  describe '#element' do
    subject { parser.element }

    it 'returns a proper quote element' do
      expect(subject).to be_a ArticleJSON::Elements::Quote
      expect(subject.type).to eq :quote
      expect(subject.float).to be :left
      expect(subject.content).to be_an Array
      expect(subject.content).to all be_a ArticleJSON::Elements::Paragraph
      expect(subject.caption).to be_an Array
      expect(subject.caption).to all be_a ArticleJSON::Elements::Text
    end
  end
end
