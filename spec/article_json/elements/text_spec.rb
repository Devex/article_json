describe ArticleJSON::Elements::Text do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: 'Foobar', bold: true, italic: true, href: '/foo' } }
  let(:hash) { params.merge(type: :text) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::Text }
    it 'has the correct values' do
      expect(subject.content).to eq hash[:content]
      expect(subject.href).to eq hash[:href]
      expect(subject.bold).to eq hash[:bold]
      expect(subject.italic).to eq hash[:italic]
    end
  end
end
