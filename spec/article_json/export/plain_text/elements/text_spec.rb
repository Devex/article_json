describe ArticleJSON::Export::PlainText::Elements::Text do
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
      it { should eq content }
    end

    context 'when the source element is bold text' do
      let(:bold) { true }
      it { should eq content }
    end

    context 'when the source element is italic text' do
      let(:italic) { true }
      it { should eq content }
    end

    context 'when the source element is italic and bold text' do
      let(:bold) { true }
      let(:italic) { true }
      it { should eq content }
    end

    context 'when the source element is a link' do
      let(:href) { '/foo/bar' }
      let(:expected_link) { '<a href="/foo/bar">Foo Bar</a>' }

      context 'with plain text' do
        it { should eq content }
      end

      context 'with bold text' do
        let(:bold) { true }
        it { should eq content }
      end

      context 'with italic text' do
        let(:italic) { true }
        it { should eq content }
      end

      context 'with italic and bold text' do
        let(:bold) { true }
        let(:italic) { true }
        it { should eq content }
      end
    end
  end
end
