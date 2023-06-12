describe ArticleJSON::Export::AppleNews::Elements::Paragraph do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Paragraph.new(content: [content_1, content_2])
  end
  let(:content_1) do
    ArticleJSON::Elements::Text.new(content: "Check “this” out: ", bold: true)
  end
  let(:content_2) do
    ArticleJSON::Elements::Text.new(content: 'Foo Bar', href: '/foo/bar')
  end
  let(:exported_text) do
    {
      role: 'body',
      text: '<strong>Check \\"this\\" out: </strong><a href="/foo/bar">Foo Bar</a>',
      format: 'html'
    }
  end

  describe '#export' do
    subject { element.export }
    it { should eq exported_text }
  end
end
