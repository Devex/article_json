describe ArticleJSON::Import::GoogleDoc::HTML::Node do
  subject(:node) { described_class.new(nokogiri_node) }
  let(:nokogiri_node) { Nokogiri::XML.fragment(xml_fragment).children.first }

  describe '#header?' do
    subject { node.header? }

    %w(h1 h2 h3 h4 h5).each do |header_tag|
      context "when the node is a <#{header_tag}>" do
        let(:xml_fragment) { "<#{header_tag}>foo</#{header_tag}>" }
        it { should be true }
      end
    end

    %w(h6 span strong em a).each do |other_tag|
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
      let(:xml_fragment) { '<p> </p>' }
      it { should be true }
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
      let(:xml_fragment) { '<p><img src="foo/bar.jpg" /></p>' }
      it { should be false }
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
end
