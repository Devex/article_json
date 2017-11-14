describe ArticleJSON::Export::PlainText::Elements::Paragraph do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Paragraph.new(content: [content_1, content_2])
  end
  let(:content_1) do
    ArticleJSON::Elements::Text.new(content: 'Check this out: ', bold: true)
  end
  let(:content_2) do
    ArticleJSON::Elements::Text.new(content: 'Foo Bar', href: '/foo/bar')
  end

  describe '#export' do
    subject { element.export }
    it { should eq "Check this out: Foo Bar\n" }
  end
end
