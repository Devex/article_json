describe ArticleJSON::Import::GoogleDoc::HTML::NodeAnalyzer do
  subject(:node) { described_class.new(nokogiri_node) }
  let(:nokogiri_node) do
    Nokogiri::HTML.fragment(xml_fragment.strip).children.first
  end

  describe '#heading?' do
    subject { node.heading? }

    %w(h1 h2 h3 h4 h5).each do |header_tag|
      context "when the node is a <#{header_tag}>" do
        context 'and it is neither a `Quote:` nor a `Textbox:` tag' do
          let(:xml_fragment) { "<#{header_tag}>foo</#{header_tag}>" }
          it { should be true }
        end

        context 'but it is a `Quote:` tag' do
          let(:xml_fragment) { "<#{header_tag}>Quote:</#{header_tag}>" }
          it { should be false }
        end

        context 'but it is a `Textbox:` tag' do
          let(:xml_fragment) { "<#{header_tag}>Textbox:</#{header_tag}>" }
          it { should be false }
        end
      end
    end

    %w(h6 span strong em a).each do |other_tag|
      context "when the node is a <#{other_tag}>" do
        let(:xml_fragment) { "<#{other_tag}>foo</#{other_tag}>" }
        it { should be false }
      end
    end
  end

  describe '#hr?' do
    subject { node.hr? }

    context 'when the node is a <hr>' do
      let(:xml_fragment) { '<hr>' }
      it { should be true }
    end

    %w(h1 span strong em a).each do |other_tag|
      context "when the node is a <#{other_tag}>" do
        let(:xml_fragment) { "<#{other_tag}>foo</#{other_tag}>" }
        it { should be false }
      end
    end
  end

  describe '#has_text?' do
    subject { node.has_text?('foo bar') }

    %w(h1 h2 p span strong em a).each do |tag|
      context "when the node is a <#{tag}> and exactly includes the text" do
        let(:xml_fragment) { "<#{tag}>foo bar</#{tag}>" }
        it { should be true }
      end
    end

    %w(h1 h2 p span strong em a).each do |tag|
      context "when the node is a <#{tag}> and includes the text" do
        let(:xml_fragment) { "<#{tag}>bar baz</#{tag}>" }
        it { should be false }
      end
    end

    %w(h1 h2 p span strong em a).each do |tag|
      context "when the node is a <#{tag}> and partially includes the text" do
        let(:xml_fragment) { "<#{tag}>foo bar baz</#{tag}>" }
        it { should be false }
      end
    end
  end

  describe '#empty?' do
    subject { node.empty? }

    context 'when the node is empty' do
      let(:xml_fragment) { '<p></p>' }
      it { should be true }
    end

    context 'when the node has only whitespaces' do
      context 'and no line breaks' do
        let(:xml_fragment) { '<p> </p>' }
        it { should be true }
      end

      context 'including line breaks' do
        let(:xml_fragment) { '<p> <br></p>' }
        it { should be false }
      end
    end

    context 'when the node has nested spans that are empty' do
      let(:xml_fragment) { '<p><span></span><span></span></p>' }
      it { should be true }
    end

    context 'when the node has nested spans with whitespaces' do
      let(:xml_fragment) { '<p><span> </span><span> </span></p>' }
      it { should be true }
    end

    context 'when the node contains text' do
      let(:xml_fragment) { '<p>foo</p>' }
      it { should be false }
    end

    context 'when the node has nested spans containing text' do
      let(:xml_fragment) { '<p><span>foo</span><span></span></p>' }
      it { should be false }
    end

    context 'when the node has a nested image tag' do
      let(:xml_fragment) { '<p><span><img src="foo/bar.jpg" /></span></p>' }
      it { should be false }
    end
  end

  describe '#paragraph?' do
    subject { node.paragraph? }

    context 'when the node is empty' do
      let(:xml_fragment) { '<p></p>' }
      it { should be false }
    end

    context 'when the node has a nested image tag' do
      let(:xml_fragment) { '<p><span><img src="foo/bar.jpg" /></span></p>' }
      it { should be false }
    end

    context 'when the node contains the text to start a text box' do
      let(:xml_fragment) { '<p><span>Textbox:</span></p>' }
      it { should be false }
    end

    context 'when the node contains the text to start a highlight text box' do
      let(:xml_fragment) { '<p><span>Highlight:</span></p>' }
      it { should be false }
    end

    context 'when the node contains the text to start a quote' do
      let(:xml_fragment) { '<p><span>Quote:</span></p>' }
      it { should be false }
    end

    context 'when the node is a header tag' do
      let(:xml_fragment) { '<h1>foo</h1>' }
      it { should be false }
    end

    context 'when the node is a <ul> tag' do
      let(:xml_fragment) { '<ul><li>Foo</li><li>Bar</li></ul>' }
      it { should be false }
    end

    context 'when the node is a <ol> tag' do
      let(:xml_fragment) { '<ol><li>Foo</li><li>Bar</li></ol>' }
      it { should be false }
    end

    context 'when the node is a just normal text' do
      let(:xml_fragment) { '<p><span>Foo</span><span>Bar</span></p>' }
      it { should be true }
    end
  end

  describe '#image?' do
    subject { node.image? }

    context 'when the node has a nested image tag' do
      let(:xml_fragment) { '<p><span><img src="foo/bar.jpg" /></span></p>' }
      it { should be true }
    end

    context 'when the node does *not* have a nested image tag' do
      let(:xml_fragment) { '<p><span>no image here</span></p>' }
      it { should be false }
    end
  end

  describe '#embed?' do
    let(:xml_fragment) { '<p><span>some embedding</span></p>' }
    it 'calls EmbeddedParser.supported?' do
      expect(ArticleJSON::Import::GoogleDoc::HTML::EmbeddedParser)
        .to receive(:supported?).with(nokogiri_node).and_return(true)
      expect(node.embed?).to be true
    end
  end

  describe '#list?' do
    subject { node.list? }

    context 'when the node is a <ul> tag' do
      let(:xml_fragment) do
        # copied from google doc example
        <<-html
          <ul class="c5 lst-kix_wco5jbr050qn-0 start">
            <li class="c3"><span class="c6">Point A</span></li>
            <li class="c3"><span class="c8">Point B</span></li>
          </ul>
        html
      end
      it { should be true }
    end

    context 'when the node is a <ol> tag' do
      let(:xml_fragment) do
        # copied from google doc example
        <<-html
          <ol class="c5 lst-kix_wco5jbr050qn-0 start">
            <li class="c3"><span class="c6">Point A</span></li>
            <li class="c3"><span class="c8">Point B</span></li>
          </ol>
        html
      end
      it { should be true }
    end

    context 'when the node is neither a <ol> nor a <ul> tag' do
      let(:xml_fragment) { '<span class="c6">Point A</span>' }
      it { should be false }
    end
  end

  describe '#text_box?' do
    subject { node.text_box? }

    context 'when the node contains the text to start a text box' do
      let(:xml_fragment) { '<p><span>Textbox:</span></p>' }
      it { should be true }
    end

    context 'when the node contains the text to start a highlight' do
      let(:xml_fragment) { '<p><span>Highlight:</span></p>' }
      it { should be true }
    end

    context 'when the node does not contain the text to start a text box' do
      let(:xml_fragment) { '<p><span>Foo Bar:</span></p>' }
      it { should be false }
    end
  end

  describe '#quote?' do
    subject { node.quote? }

    context 'when the node contains the text to start a quote' do
      let(:xml_fragment) { '<p><span>Quote:</span></p>' }
      it { should be true }
    end

    context 'when the node does not contain the text to start a quote' do
      let(:xml_fragment) { '<p><span>Foo Bar:</span></p>' }
      it { should be false }
    end
  end

  describe '#br?' do
    subject { node.br? }

    context 'when the node is a <br> itself' do
      let(:xml_fragment) { '<br>' }
      it { should be true }
    end

    context 'when the node is a span' do
      context 'and contains text' do
        let(:xml_fragment) { '<span>Foo Bar:<br></p>' }
        it { should be false }
      end

      context 'and only contains a linebreak' do
        let(:xml_fragment) { '<span><br></p>' }
        it { should be true }
      end

      context 'and only contains linebreaks and spaces' do
        let(:xml_fragment) { '<span><br>  <br> </p>' }
        it { should be true }
      end
    end
  end

  describe '#type' do
    subject { node.type }

    context 'when the node is empty' do
      let(:xml_fragment) { '<p></p>' }
      it { should eq :empty }
    end

    context 'when the node is a horizontal line' do
      let(:xml_fragment) { '<hr>' }
      it { should eq :hr }
    end

    context 'when the node has a nested image tag' do
      let(:xml_fragment) { '<p><span><img src="foo/bar.jpg" /></span></p>' }
      it { should eq :image }
    end

    context 'when the node contains the text to start a text box' do
      let(:xml_fragment) { '<p><span>Textbox:</span></p>' }
      it { should eq :text_box }
    end

    context 'when the node contains the text to start a highlight' do
      let(:xml_fragment) { '<p><span>Highlight:</span></p>' }
      it { should eq :text_box }
    end

    context 'when the node contains the text to start a quote' do
      let(:xml_fragment) { '<p><span>Quote:</span></p>' }
      it { should eq :quote }
    end

    context 'when the node is a header tag' do
      let(:xml_fragment) { '<h1>foo</h1>' }
      it { should eq :heading }
    end

    context 'when the node is a <ul> tag' do
      let(:xml_fragment) { '<ul><li>Foo</li><li>Bar</li></ul>' }
      it { should eq :list }
    end

    context 'when the node is a <ol> tag' do
      let(:xml_fragment) { '<ol><li>Foo</li><li>Bar</li></ol>' }
      it { should eq :list }
    end

    context 'when the node is a just normal text' do
      let(:xml_fragment) { '<p><span>Foo</span><span>Bar</span></p>' }
      it { should eq :paragraph }
    end

    context 'when the node is a embedding' do
      let(:xml_fragment) { '<p><span>some embedding</span></p>' }
      it 'calls EmbeddedParser.supported?' do
        expect(ArticleJSON::Import::GoogleDoc::HTML::EmbeddedParser)
          .to receive(:supported?).with(nokogiri_node).and_return(true)
        expect(subject).to eq :embed
      end
    end

    context 'when the node is something else that we do not support' do
      let(:xml_fragment) { '<google-drawing>fancy-drawing</google-drawing>' }
      it { should eq :unknown }
    end
  end
end
