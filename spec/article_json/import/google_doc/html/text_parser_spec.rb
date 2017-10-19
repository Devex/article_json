describe ArticleJSON::Import::GoogleDoc::HTML::TextParser do
  subject(:element) do
    described_class.new(node: node, css_analyzer: css_analyzer)
  end
  let(:node) do
    Nokogiri::HTML.fragment(xml_fragment.strip).children.first
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
    context 'when it only includes text' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it { should eq 'foo bar' }
    end

    context 'when it includes a line break' do
      let(:xml_fragment) { '<span>foo<br>bar</span>' }
      it { should eq "foo\nbar" }
    end

    context 'when it includes multiple consecutive line breaks' do
      let(:xml_fragment) { '<span>foo  <br> <br>  <br>bar</span>' }
      it { should eq "foo\nbar" }
    end
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

  describe '#element' do
    subject { element.element }

    context 'when having a simple text' do
      let(:xml_fragment) { '<span>foo bar</span>' }
      it 'returns a proper Hash' do
        expect(subject).to be_a ArticleJSON::Elements::Text
        expect(subject.type).to eq :text
        expect(subject.content).to eq 'foo bar'
        expect(subject.bold).to be false
        expect(subject.italic).to be false
        expect(subject.href).to be nil
      end
    end

    context 'when having a styles text and a link' do
      let(:xml_fragment) do
        <<-html
          <span class="bold-italic"><a href="https://devex.com">foo bar</a></span>
        html
      end
      it 'returns a proper Hash' do
        expect(subject).to be_a ArticleJSON::Elements::Text
        expect(subject.type).to eq :text
        expect(subject.content).to eq 'foo bar'
        expect(subject.bold).to be true
        expect(subject.italic).to be true
        expect(subject.href).to eq 'https://devex.com'
      end
    end
  end

  describe '.extract' do
    subject { described_class.extract(node: node, css_analyzer: css_analyzer) }

    let(:xml_fragment) do
      <<-html
        <p>
          <span class="bold">A </span>
          <span><a href="https://devex.com">link</a></span>
          <span class="italic"> and styling</span>
          <span> with some <br>line breaks</span>
          <span><br></span>
        </p>
      html
    end

    it 'parses all text sub-nodes' do
      expect(subject.size).to eq 5
      expect(subject).to all be_a ArticleJSON::Elements::Text

      expect(subject[0].content).to eq 'A '
      expect(subject[0].bold).to be true
      expect(subject[0].italic).to be false
      expect(subject[0].href).to be nil

      expect(subject[1].content).to eq 'link'
      expect(subject[1].bold).to be false
      expect(subject[1].italic).to be false
      expect(subject[1].href).to eq 'https://devex.com'

      expect(subject[2].content).to eq ' and styling'
      expect(subject[2].bold).to be false
      expect(subject[2].italic).to be true
      expect(subject[2].href).to be nil

      expect(subject[3].content).to eq " with some\nline breaks"
      expect(subject[3].bold).to be false
      expect(subject[3].italic).to be false
      expect(subject[3].href).to be nil

      expect(subject[4].content).to eq "\n"
      expect(subject[4].bold).to be false
      expect(subject[4].italic).to be false
      expect(subject[4].href).to be nil
    end
  end
end
