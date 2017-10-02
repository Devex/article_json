describe ArticleJSON::Export::AMP::Elements::TextBox do
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
    subject { element.export.to_html(save_with: 0) }

    context 'when the box is not floating' do
      let(:float) { nil }
      it { should eq '<div class="text-box"><p>Foo Bar</p></div>' }
    end

    context 'when the box is floating left' do
      let(:float) { :left }
      it { should eq '<div class="text-box float-left"><p>Foo Bar</p></div>' }
    end

    context 'when the box is floating right' do
      let(:float) { :right }
      it { should eq '<div class="text-box float-right"><p>Foo Bar</p></div>' }
    end
  end
end
