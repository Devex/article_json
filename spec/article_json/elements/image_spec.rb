describe ArticleJSON::Elements::Image do
  subject(:element) { described_class.new(**params) }
  let(:params) { { source_url: 'foo.jpg', caption: [caption], float: :left } }
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :image, caption: [caption.to_h]) }
  end
end
