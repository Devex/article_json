describe ArticleJSON::Export::PlainText::Elements::List do

  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::List.new(
      content: [
        content_factory.call('Foo'),
        content_factory.call("Bar\nBar"),
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
    subject { element.export }

    context 'when it is an ordered list' do
      let(:list_type) { :ordered }
      it { should eq "1. Foo\n2. Bar\n   Bar\n3. Baz\n\n" }
    end

    context 'when it is an unordered list' do
      let(:list_type) { :unordered }
      it { should eq "- Foo\n- Bar\n  Bar\n- Baz\n\n" }
    end
  end
end
