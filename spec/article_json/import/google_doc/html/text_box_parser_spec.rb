describe ArticleJSON::Import::GoogleDoc::HTML::TextBoxParser do
  subject(:parser) do
    described_class.new(nodes: node.children, css_analyzer: css_analyzer)
  end

  let(:node) { Nokogiri::HTML.fragment(html.strip) }
  let(:html) do
    <<-html
      <h2 class="css_class"><span>This is a text box!</span></h2>
      <p><span>With a paragraph.</span></p>
      <p><span>And another one...</span></p>
    html
  end

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
      expect(subject.size).to eq 3

      expect(subject[0]).to be_a ArticleJSON::Elements::Heading
      expect(subject[0].content).to eq 'This is a text box!'

      expect(subject[1]).to be_a ArticleJSON::Elements::Paragraph
      expect(subject[1].content.first.content).to eq 'With a paragraph.'

      expect(subject[2]).to be_a ArticleJSON::Elements::Paragraph
      expect(subject[2].content.first.content).to eq 'And another one...'
    end

    context 'when the text box contains a list' do
      let(:html) do
        <<-html
          <h2 class="css_class"><span>Text box including a list!</span></h2>
          <ol><li><span>foo bar</span></li></ol>
        html
      end

      it 'returns a heading and a list element' do
        expect(subject).to be_an Array
        expect(subject.size).to eq 2

        expect(subject[0]).to be_a ArticleJSON::Elements::Heading
        expect(subject[0].content).to eq 'Text box including a list!'

        expect(subject[1]).to be_a ArticleJSON::Elements::List
      end
    end
  end

  describe '#.tags' do
    subject { parser.tags }

    context 'when there are tags' do
      let(:html) do
        <<-html 
          <span>&nbsp;[foo bar]</span>
          <h2 class="css_class"><span>Text box including a list!</span></h2>
          <ol><li><span>foo bar</span></li></ol>
        html
      end
      it { should match_array %w(foo bar) }
    end

    context 'when there are no tags' do
      it { should match_array [] }
    end
  end

  describe '#element' do
    subject { parser.element }

    it 'returns a proper text box element' do
      expect(subject).to be_a ArticleJSON::Elements::TextBox
      expect(subject.type).to eq :text_box
      expect(subject.float).to eq :left
      expect(subject.content).to be_an Array
      expect(subject.content[0]).to be_a ArticleJSON::Elements::Heading
      expect(subject.content[1]).to be_a ArticleJSON::Elements::Paragraph
      expect(subject.content[2]).to be_a ArticleJSON::Elements::Paragraph
    end
  end
end
