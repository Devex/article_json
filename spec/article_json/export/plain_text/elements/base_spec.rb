describe ArticleJSON::Export::PlainText::Elements::Base do
  subject(:element) { described_class.new(source_element) }

  describe '#export' do
    subject { element.export }

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
      it { should eq "\n\n\nFoo Bar\n\n" }
    end

    context 'when the source element is a paragraph' do
      let(:source_element) { sample_paragraph }
      it { should eq "Foo Bar\n" }
    end

    context 'when the source element is a list' do
      let(:source_element) do
        ArticleJSON::Elements::List.new(content: [sample_paragraph])
      end
      it { should eq "- Foo Bar\n\n" }
    end

    context 'when the source element is a image' do
      let(:source_element) do
        ArticleJSON::Elements::Image.new(
          source_url: '/foo/bar.jpg',
          caption: [sample_text]
        )
      end
      it { should eq '' }
    end

    context 'when the source element is a text box' do
      let(:source_element) do
        ArticleJSON::Elements::TextBox.new(content: [sample_paragraph])
      end
      it { should eq '' }
    end

    context 'when the source element is a quote' do
      let(:source_element) do
        ArticleJSON::Elements::Quote.new(
          content: [sample_paragraph],
          caption: [ArticleJSON::Elements::Text.new(content: 'Baz')]
        )
      end
      let(:expected_text) do
        "\nFoo Bar\n --Baz\n\n"
      end
      it { should eq expected_text }
    end

    context 'when the source element is an embedded element' do
      let(:source_element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :something,
          embed_id: 666,
          caption: [sample_text]
        )
      end
      it { should eq '' }
    end
  end

  describe '.build' do
    subject { described_class.build(element) }

    context 'when the element type is text' do
      let(:element) { ArticleJSON::Elements::Text.new(content: '') }
      it { should be_a ArticleJSON::Export::PlainText::Elements::Text }
    end

    context 'when the element type is heading' do
      let(:element) { ArticleJSON::Elements::Heading.new(content: 1, level: 1) }
      it { should be_a ArticleJSON::Export::PlainText::Elements::Heading }
    end

    context 'when the element type is paragraph' do
      let(:element) { ArticleJSON::Elements::Paragraph.new(content: []) }
      it { should be_a ArticleJSON::Export::PlainText::Elements::Paragraph }
    end

    context 'when the element type is list' do
      let(:element) { ArticleJSON::Elements::List.new(content: []) }
      it { should be_a ArticleJSON::Export::PlainText::Elements::List }
    end

    context 'when the element type is image' do
      let(:element) do
        ArticleJSON::Elements::Image.new(source_url: '', caption: [])
      end
      it { should be nil }
    end

    context 'when the element type is text_box' do
      let(:element) { ArticleJSON::Elements::TextBox.new(content: []) }
      it { should be nil }
    end

    context 'when the element type is quote' do
      let(:element) do
        ArticleJSON::Elements::Quote.new(content: [], caption: [])
      end
      it { should be_a ArticleJSON::Export::PlainText::Elements::Quote }
    end

    context 'when the element type is embed' do
      let(:element) do
        ArticleJSON::Elements::Embed
          .new(embed_type: '', embed_id: '', caption: [])
      end
      it { should be nil }
    end
  end

  describe '.exporter_by_type' do
    subject { described_class.exporter_by_type(element_type) }

    context 'when the element type is text' do
      let(:element_type) { :text }
      it { should be ArticleJSON::Export::PlainText::Elements::Text }
    end

    context 'when the element type is heading' do
      let(:element_type) { :heading }
      it { should be ArticleJSON::Export::PlainText::Elements::Heading }
    end

    context 'when the element type is paragraph' do
      let(:element_type) { :paragraph }
      it { should be ArticleJSON::Export::PlainText::Elements::Paragraph }
    end

    context 'when the element type is list' do
      let(:element_type) { :list }
      it { should be ArticleJSON::Export::PlainText::Elements::List }
    end

    context 'when the element type is image' do
      let(:element_type) { :image }
      it { should be nil }
    end

    context 'when the element type is text_box' do
      let(:element_type) { :text_box }
      it { should be nil }
    end

    context 'when the element type is quote' do
      let(:element_type) { :quote }
      it { should be ArticleJSON::Export::PlainText::Elements::Quote }
    end

    context 'when the element type is embed' do
      let(:element_type) { :embed }
      it { should be nil }
    end

    context 'when the element was additionally registered' do
      before do
        ArticleJSON.configure do |c|
          c.register_element_exporters(:plain_text, foo: Object)
        end
      end
      let(:element_type) { :foo }
      it { should be Object }
    end
  end

  describe '.namespace' do
    subject { described_class.namespace }
    it { should be_a Module }
    it { should eq ArticleJSON::Export::PlainText::Elements }
  end
end
