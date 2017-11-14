describe ArticleJSON::Export::PlainText::Elements::Quote do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Quote.new(
      content: [
        ArticleJSON::Elements::Paragraph.new(
          content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
        ),
      ],
      caption: caption,
      float: float
    )
  end
  let(:float) { nil }
  let(:caption) { [ArticleJSON::Elements::Text.new(content: 'Baz')] }

  describe '#export' do
    subject { element.export }

    context 'when the quote is not floating' do
      it { should eq "\nFoo Bar\n --Baz\n\n" }
    end

    context 'when the quote is floating on the left' do
      let(:float) { :left }
      it { should eq "\nFoo Bar\n --Baz\n\n" }
    end

    context 'when the quote is floating on the right' do
      let(:float) { :right }
      it { should eq "\nFoo Bar\n --Baz\n\n" }
    end

    context 'when no caption is present' do
      let(:caption) { [] }
      it { should eq "\nFoo Bar\n\n" }
    end
  end
end
