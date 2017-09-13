describe ArticleJSON::Elements::List do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: [content], list_type: :ordered } }
  let(:content) do
    ArticleJSON::Elements::Paragraph.new(
      content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
    )
  end

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :list, content: [content.to_h]) }
  end
end
