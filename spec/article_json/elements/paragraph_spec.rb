describe ArticleJSON::Elements::Paragraph do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: [content] } }
  let(:content) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
  let(:hash) { params.merge(type: :paragraph, content: [content.to_h]) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::Paragraph }
    it 'has the correct values' do
      expect(subject.content).to all be_a ArticleJSON::Elements::Text
    end
  end
end
