describe ArticleJSON::Export::FacebookInstantArticle::Elements::Quote do
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
    subject { element.export.to_html(save_with: 0) }

    context 'when the quote is not floating' do
      let(:float) { nil }
      let(:expected_html) do
        '<aside><p>Foo Bar</p><cite>Baz</cite></aside>'
      end
      it { should eq expected_html }
    end

    context 'when the quote is floating on the left' do
      let(:float) { :left }
      let(:expected_html) do
        '<aside><p>Foo Bar</p><cite>Baz</cite></aside>'
      end
      it { should eq expected_html }
    end

    context 'when the quote is floating on the right' do
      let(:float) { :right }
      let(:expected_html) do
        '<aside><p>Foo Bar</p><cite>Baz</cite></aside>'
      end
      it { should eq expected_html }
    end

    context 'when no caption is present' do
      let(:caption) { [] }
      it { should eq '<aside><p>Foo Bar</p></aside>' }
    end
  end
end
