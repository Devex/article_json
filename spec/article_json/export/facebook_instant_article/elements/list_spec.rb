describe ArticleJSON::Export::FacebookInstantArticle::Elements::List do

  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::List.new(
      content: [
        content_factory.call('Foo'),
        content_factory.call('Bar'),
        content_factory.call('Baz'),
      ],
      list_type: list_type
    )
  end
  let(:content_factory) do
    ->(text) do
      ArticleJSON::Elements::Paragraph.new(
        content: [
          ArticleJSON::Elements::Text.new(content: text)
        ]
      )
    end
  end

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    context 'when it is an ordered list' do
      let(:list_type) { :ordered }
      let(:expected_html) do
        '<ol><li><p>Foo</p></li><li><p>Bar</p></li><li><p>Baz</p></li></ol>'
      end
      it { should eq expected_html }
    end

    context 'when it is an unordered list' do
      let(:list_type) { :unordered }
      let(:expected_html) do
        '<ul><li><p>Foo</p></li><li><p>Bar</p></li><li><p>Baz</p></li></ul>'
      end
      it { should eq expected_html }
    end
  end
end
