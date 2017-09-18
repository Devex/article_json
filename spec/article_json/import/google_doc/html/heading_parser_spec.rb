describe ArticleJSON::Import::GoogleDoc::HTML::HeadingParser do
  subject(:parser) { described_class.new(node: node) }

  let(:node) { Nokogiri::HTML.fragment(html.strip).first_element_child }
  let(:html) { '<h1>Foo Bar</h1>' }

  describe '#content' do
    subject { parser.content }
    it { should eq 'Foo Bar' }
  end

  describe '#level' do
    subject { parser.level }

    context 'when it is a <h1> tag' do
      let(:html) { '<h1>Foo Bar</h3>' }
      it { should eq 1 }
    end

    context 'when it is a <h2> tag' do
      let(:html) { '<h2>Foo Bar</h3>' }
      it { should eq 2 }
    end

    context 'when it is a <h3> tag' do
      let(:html) { '<h3>Foo Bar</h3>' }
      it { should eq 3 }
    end

    context 'when it is a <h4> tag' do
      let(:html) { '<h4>Foo Bar</h3>' }
      it { should eq 4 }
    end

    context 'when it is a <h5> tag' do
      let(:html) { '<h5>Foo Bar</h3>' }
      it { should eq 5 }
    end
  end

  describe 'parser' do
    subject { parser.element }

    it 'returns a proper Hash' do
      expect(subject).to be_a ArticleJSON::Elements::Heading
      expect(subject.type).to eq :heading
      expect(subject.level).to eq 1
      expect(subject.content).to eq 'Foo Bar'
    end
  end
end
