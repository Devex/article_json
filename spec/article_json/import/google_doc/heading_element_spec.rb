describe ArticleJSON::Import::GoogleDoc::HTML::HeadingElement do
  subject(:element) { described_class.new(node: node) }
  let(:node) { Nokogiri::HTML.fragment(xml_fragment.strip).first_element_child }
  let(:xml_fragment) { '<h1>Foo Bar</h1>' }

  describe '#content' do
    subject { element.content }
    it { should eq 'Foo Bar' }
  end

  describe '#level' do
    subject { element.level }

    context 'when it is a <h1> tag' do
      let(:xml_fragment) { '<h1>Foo Bar</h3>' }
      it { should eq 1 }
    end

    context 'when it is a <h2> tag' do
      let(:xml_fragment) { '<h2>Foo Bar</h3>' }
      it { should eq 2 }
    end

    context 'when it is a <h3> tag' do
      let(:xml_fragment) { '<h3>Foo Bar</h3>' }
      it { should eq 3 }
    end

    context 'when it is a <h4> tag' do
      let(:xml_fragment) { '<h4>Foo Bar</h3>' }
      it { should eq 4 }
    end

    context 'when it is a <h5> tag' do
      let(:xml_fragment) { '<h5>Foo Bar</h3>' }
      it { should eq 5 }
    end
  end

  describe 'to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :heading
      expect(subject[:level]).to eq 1
      expect(subject[:content]).to eq 'Foo Bar'
    end
  end
end
