describe ArticleJSON::Export::PlainText::Elements::Image do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Image.new(
      source_url: '/foo/bar.jpg',
      caption: caption,
      float: float
    )
  end
  let(:float) { nil }
  let(:caption) { [ArticleJSON::Elements::Text.new(content: 'Foo Bar')] }

  describe '#export' do
    subject { element.export }

    context 'when the image is not floating' do
      it { should eq '' }
    end

    context 'when the image is floating on the left' do
      let(:float) { :left }
      it { should eq '' }
    end

    context 'when the image is floating on the right' do
      let(:float) { :right }
      it { should eq '' }
    end

    context 'when no caption is provided' do
      let(:caption) { [] }
      let(:expected_text) { '<figure><img src="/foo/bar.jpg"></figure>' }
      it { should eq '' }
    end
  end
end
