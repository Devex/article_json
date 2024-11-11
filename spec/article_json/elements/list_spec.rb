describe ArticleJSON::Elements::List do
  subject(:element) { described_class.new(**params) }

  let(:params) { { content: [content], list_type: :ordered } }
  let(:content) do
    ArticleJSON::Elements::Paragraph.new(
      content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
    )
  end
  let(:hash) { params.merge(type: :list, content: [content.to_h]) }

  describe '#to_h' do
    subject { element.to_h }

    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }

    it { should be_a ArticleJSON::Elements::List }

    it 'has the correct values' do
      expect(subject.content).to all be_a ArticleJSON::Elements::Paragraph
      expect(subject.list_type).to eq hash[:list_type]
    end
  end
end
