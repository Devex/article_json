describe ArticleJSON::Import::GoogleDoc::HTML::TextBoxElement do
  subject(:element) do
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
    subject { element.float }
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
    subject { element.content }

    it 'returns a list of paragraph and heading elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 3

      expect(subject[0])
        .to be_a ArticleJSON::Import::GoogleDoc::HTML::HeadingElement
      expect(subject[0].content).to eq 'This is a text box!'

      expect(subject[1])
        .to be_a ArticleJSON::Import::GoogleDoc::HTML::ParagraphElement
      expect(subject[1].content.first.content).to eq 'With a paragraph.'

      expect(subject[2])
        .to be_a ArticleJSON::Import::GoogleDoc::HTML::ParagraphElement
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

        expect(subject[0])
          .to be_a ArticleJSON::Import::GoogleDoc::HTML::HeadingElement
        expect(subject[0].content).to eq 'Text box including a list!'

        expect(subject[1])
          .to be_a ArticleJSON::Import::GoogleDoc::HTML::ListElement
      end
    end
  end

  describe '#to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :text_box
      expect(subject[:float]).to eq :left
      expect(subject[:content]).to be_an Array
      expect(subject[:content]).to all be_a Hash
    end
  end
end
