describe ArticleJSON::Export::AppleNews::Elements::Text do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Text.new(
      content: content,
      bold: bold,
      italic: italic,
      href: href
    )
  end
  let(:content) { 'Foo Bar' }
  let(:bold) { false }
  let(:italic) { false }
  let(:href) { nil }

  describe '#export' do
    subject { element.export }

    context 'when the source element is plain text' do
      it { should eq content }
    end

    context 'when the source element contains a newline character' do
      let(:content) { "Foo\nBar" }
      let(:output) { 'Foo<br>Bar' }
      it { should eq output }
    end

    context 'when the source element is bold text' do
      let(:bold) { true }
      let(:output) { '<strong>Foo Bar</strong>' }
      it { should eq output }
    end

    context 'when the source element is italic text' do
      let(:italic) { true }
      let(:output) { '<em>Foo Bar</em>' }
      it { should eq output }
    end

    context 'when the source element is italic and bold text' do
      let(:bold) { true }
      let(:italic) { true }
      let(:output) { '<strong><em>Foo Bar</em></strong>' }
      it { should eq output }
    end

    context 'when the source element has unsupported tags' do
      let(:content) do
        'Normal text<script async>Some Script here</script>' \
        '<select><option>OPtion 1</option></select>' \
        '<form>form content</form>' \
        '<p><em>text</em></p>' \
        '<form><a href="#">Link</a></form>'
      end
      let(:output) { 'Normal text<p><em>text</em></p>' }
      it { should eq output }
    end
  end
end
