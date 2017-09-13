describe ArticleJSON::Elements::Heading do
  subject(:element) { described_class.new(**params) }
  let(:params) { { level: 42, content: 'Foobar' } }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :heading) }
  end
end
