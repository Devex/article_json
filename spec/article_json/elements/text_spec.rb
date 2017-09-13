describe ArticleJSON::Elements::Text do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: 'Foobar', bold: true, italic: true, href: '/foo' } }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq params.merge(type: :text) }
  end
end
