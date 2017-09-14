describe ArticleJSON::Elements::Embed do
  subject(:element) { described_class.new(**params) }
  let(:params) do
    {
      embed_type: :something,
      embed_id: '12345',
      caption: [caption],
      tags: %w(foo bar)
    }
  end
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :embed, caption: [caption.to_h]) }
  end
end
