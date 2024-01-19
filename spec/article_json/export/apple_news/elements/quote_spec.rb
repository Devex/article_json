describe ArticleJSON::Export::AppleNews::Elements::Quote do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Quote.new(
      float: float,
      content: quote,
      caption: caption,
    )
  end
  let(:quote) do
    [
      ArticleJSON::Elements::Paragraph.new(
        content: [
          ArticleJSON::Elements::Text.new(
            content: quote_text,
            bold: bold,
            italic: italic,
            href: nil,
          )
        ]
      )
    ]
  end
  let(:caption) do
    [
      ArticleJSON::Elements::Text.new(
        content: author,
        bold: false,
        italic: false,
        href: href,
      )
    ]
  end
  let(:output) do
    [
      {
        role: 'pullquote',
        text: quote_text_output,
        format: 'html',
        layout: 'pullquoteLayout',
        textStyle: 'pullquoteStyle',
      },
      {
        role: 'author',
        text: author,
        format: 'html',
        layout: 'pullquoteAttributeLayout',
        textStyle: 'quoteAttributeStyle',
      }
    ]
  end
  let(:quote_text) { 'Foo Bar' }
  let(:quote_text_output) { 'Foo Bar' }
  let(:author) { 'Homer Simpson'}
  let(:float) { nil }
  let(:bold) { false }
  let(:italic) { false }
  let(:href) { nil }

  describe '#export' do
    subject { element.export }

    context 'when the source element is plain text' do
      it { should eq output }
    end

    context 'when the source element contains a newline character' do
      let(:quote_text) { "Foo\nBar" }
      let(:quote_text_output) { 'Foo<br>Bar' }
      it { should eq output }
    end

    context 'when the source element contains bold text' do
      let(:bold) { true }
      let(:quote_text_output) { '<strong>Foo Bar</strong>' }
      it { should eq output }
    end

    context 'when the source element contains a italic text' do
      let(:italic) { true }
      let(:quote_text_output) { '<em>Foo Bar</em>' }
      it { should eq output }
    end

    context 'when the source element contains both bold and italic text' do
      let(:bold) { true }
      let(:italic) { true }
      let(:quote_text_output) { '<strong><em>Foo Bar</em></strong>' }
      it { should eq output }
    end

    context 'when the source element has unsupported tags' do
      let(:quote_text) do
        'Normal text<script async>Some Script here</script>' \
        '<select><option>OPtion 1</option></select>' \
        '<form>form content</form>' \
        '<p><em>text</em></p>' \
      end
      let(:quote_text_output) { 'Normal text<p><em>text</em></p>' }
      it { should eq output }
    end
  end
end
