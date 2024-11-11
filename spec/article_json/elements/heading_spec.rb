describe ArticleJSON::Elements::Heading do
  subject(:element) { described_class.new(**params) }

  let(:params) { { level: 42, content: 'Foobar' } }
  let(:hash) { params.merge(type: :heading) }

  describe '#to_h' do
    subject { element.to_h }

    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }

    it { should be_a ArticleJSON::Elements::Heading }

    it 'has the correct values' do
      expect(subject.level).to eq hash[:level]
      expect(subject.content).to eq hash[:content]
    end
  end
end
