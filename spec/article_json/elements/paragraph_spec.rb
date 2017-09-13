describe ArticleJSON::Elements::Paragraph do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: [content] } }
  let(:content) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :paragraph, content: [content.to_h]) }
  end
end
