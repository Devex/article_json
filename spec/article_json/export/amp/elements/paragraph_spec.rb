describe ArticleJSON::Export::HTML::Elements::Paragraph do
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
    subject { element.export.to_html(save_with: 0) }
    let(:expected_html) do
      '<p><strong>Check this out: </strong><a href="/foo/bar">Foo Bar</a></p>'
    end
    it { should eq expected_html }
  end
end
