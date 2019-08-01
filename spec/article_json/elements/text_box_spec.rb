describe ArticleJSON::Elements::TextBox do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: [content], float: :right, tags: [] } }
  let(:content) do
    ArticleJSON::Elements::Paragraph.new(
      content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
    )
  end
  let(:hash) { params.merge(type: :text_box, content: [content.to_h]) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::TextBox }
    it 'has the correct values' do
      expect(subject.content).to all be_a ArticleJSON::Elements::Paragraph
      expect(subject.float).to eq hash[:float]
    end
  end
end
