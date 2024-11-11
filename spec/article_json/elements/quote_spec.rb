describe ArticleJSON::Elements::Quote do
  subject(:element) { described_class.new(**params) }

  let(:params) { { content: [content], caption: [caption], float: :left } }
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
  let(:content) do
    ArticleJSON::Elements::Paragraph.new(
      content: [ArticleJSON::Elements::Text.new(content: 'Bar Baz')]
    )
  end
  let(:hash) do
    {
      type: :quote,
      content: [content.to_h],
      caption: [caption.to_h],
      float: :left,
    }
  end

  describe '#to_h' do
    subject { element.to_h }

    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }

    it { should be_a ArticleJSON::Elements::Quote }

    it 'has the correct values' do
      expect(subject.content).to all be_a ArticleJSON::Elements::Paragraph
      expect(subject.caption).to all be_a ArticleJSON::Elements::Text
      expect(subject.float).to eq hash[:float]
    end
  end
end
