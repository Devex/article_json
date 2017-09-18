describe ArticleJSON::Export::HTML::Elements::Base do
  subject(:element) { described_class.new(source_element) }

  describe '#build' do
    subject { element.build.to_html(save_with: 0) }

    let(:sample_text) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
    let(:sample_paragraph) do
      ArticleJSON::Elements::Paragraph.new(content: [sample_text])
    end

    context 'when the source element is a text' do
      let(:source_element) { sample_text }
      it { should eq 'Foo Bar' }
    end

    context 'when the source element is a heading' do
      let(:source_element) do
        ArticleJSON::Elements::Heading.new(content: 'Foo Bar', level: 1)
      end
      it { should eq '<h1>Foo Bar</h1>' }
    end

    context 'when the source element is a paragraph' do
      let(:source_element) { sample_paragraph }
      it { should eq '<p>Foo Bar</p>' }
    end

    context 'when the source element is a list' do
      let(:source_element) do
        ArticleJSON::Elements::List.new(content: [sample_paragraph])
      end
      it { should eq '<ul><li><p>Foo Bar</p></li></ul>' }
    end

    context 'when the source element is a image' do
      let(:source_element) do
        ArticleJSON::Elements::Image.new(
          source_url: '/foo/bar.jpg',
          caption: [sample_text]
        )
      end
      let(:expected_html) do
        '<figure><img src="/foo/bar.jpg">' \
          '<figcaption>Foo Bar</figcaption></figure>'
      end
      it { should eq expected_html }
    end

    context 'when the source element is a text box' do
      let(:source_element) do
        ArticleJSON::Elements::TextBox.new(content: [sample_paragraph])
      end
      it { should eq '<div class="text-box"><p>Foo Bar</p></div>' }
    end

    context 'when the source element is a quote' do
      let(:source_element) do
        ArticleJSON::Elements::Quote.new(
          content: [sample_paragraph],
          caption: [ArticleJSON::Elements::Text.new(content: 'Baz')]
        )
      end
      it { should eq '<aside><p>Foo Bar</p><small>Baz</small></aside>' }
    end
  end

  describe '#element_classes' do
    subject { described_class.element_classes }
    it { should be_a Hash }
    it('should have Symbol-keys') { expect(subject.keys).to all be_a Symbol }
    it('should have sub classes as values') do
      expect(subject.values.map(&:allocate)).to all be_a described_class
    end
  end
end
