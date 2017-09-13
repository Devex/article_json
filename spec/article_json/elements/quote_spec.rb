describe ArticleJSON::Elements::Quote do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: [content], caption: [caption], float: :left } }
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
  let(:content) do
    ArticleJSON::Elements::Paragraph.new(
      content: [ArticleJSON::Elements::Text.new(content: 'Bar Baz')]
    )
  end

  describe '#to_h' do
    subject { element.to_h }
    let(:expected_hash) do
      {
        type: :quote,
        content: [content.to_h],
        caption: [caption.to_h],
        float: :left,
      }
    end

    it { should be_a Hash }
    it { should eq expected_hash }
  end
end
