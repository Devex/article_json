describe ArticleJSON::Export::FacebookInstantArticle::Elements::TextBox do
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

    shared_examples 'for an ASCII-art text box' do
      it 'should render an ASCII-art formatted text box' do
        is_expected.to be_a String
        is_expected
          .to eq '<div class="text-box">' \
                   '<p>────────</p>'\
                   '<p>Foo Bar</p>'\
                   '<p>────────</p>'\
                 '</div>'
      end
    end

    context 'when the box is not floating' do
      let(:float) { nil }
      include_examples 'for an ASCII-art text box'
    end

    context 'when the box is floating left' do
      let(:float) { :left }
      include_examples 'for an ASCII-art text box'
    end

    context 'when the box is floating right' do
      let(:float) { :right }
      include_examples 'for an ASCII-art text box'
    end
  end
end
