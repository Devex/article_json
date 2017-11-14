describe ArticleJSON::Export::PlainText::Elements::TextBox do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::TextBox.new(
      content: [
        ArticleJSON::Elements::Paragraph.new(
          content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
        ),
      ],
      float: float
    )
  end

  describe '#export' do
    subject { element.export }

    context 'when the box is not floating' do
      let(:float) { nil }
      it { should eq '' }
    end

    context 'when the box is floating left' do
      let(:float) { :left }
      it { should eq '' }
    end

    context 'when the box is floating right' do
      let(:float) { :right }
      it { should eq '' }
    end
  end
end
