describe ArticleJSON::Export::HTML::Elements::Quote do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Quote.new(
      content: [
        ArticleJSON::Elements::Paragraph.new(
          content: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')]
        ),
      ],
      caption: [ArticleJSON::Elements::Text.new(content: 'Baz')],
      float: float
    )
  end

  describe '#build' do
    subject { element.build.to_html(save_with: 0) }

    context 'when the quote is not floating' do
      let(:float) { nil }
      it { should eq '<aside><p>Foo Bar</p><small>Baz</small></aside>' }
    end

    context 'when the quote is floating on the left' do
      let(:float) { :left }
      let(:expected_html) do
        '<aside class="float-left"><p>Foo Bar</p><small>Baz</small></aside>'
      end
      it { should eq expected_html }
    end

    context 'when the quote is floating on the right' do
      let(:float) { :right }
      let(:expected_html) do
        '<aside class="float-right"><p>Foo Bar</p><small>Baz</small></aside>'
      end
      it { should eq expected_html }
    end
  end
end
