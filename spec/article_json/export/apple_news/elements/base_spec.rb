describe ArticleJSON::Export::AppleNews::Elements::Base do
  subject(:element) { described_class.new(source_element) }

  describe '#export' do
    subject { element.export }

    let(:sample_text) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

    context 'when the source element is a text' do
      let(:source_element) { sample_text }
      it { should eq 'Foo Bar' }
    end

    context 'when the source element is a heading' do
      let(:source_element) do
        ArticleJSON::Elements::Heading.new(content: 'Foo Bar', level: 1)
      end
      let(:heading) { { role: 'heading1', text: 'Foo Bar' } }
      it { should eq heading }
    end

    context 'when the source element is a paragraph' do
      let(:source_element) do
        ArticleJSON::Elements::Paragraph.new(content: [sample_text])
      end
      let(:paragraph) { { role: 'body', text: 'Foo Bar' } }
      it { should eq paragraph }
    end
  end

  describe '.build' do
    subject { described_class.build(element) }

    context 'when the element type is text' do
      let(:element) { ArticleJSON::Elements::Text.new(content: '') }
      it { should be_a ArticleJSON::Export::AppleNews::Elements::Text }
    end

    context 'when the element type is heading' do
      let(:element) { ArticleJSON::Elements::Heading.new(content: 1, level: 1) }
      it { should be_a ArticleJSON::Export::AppleNews::Elements::Heading }
    end

    context 'when the element type is paragraph' do
      let(:element) { ArticleJSON::Elements::Paragraph.new(content: []) }
      it { should be_a ArticleJSON::Export::AppleNews::Elements::Paragraph }
    end
  end

  describe '.exporter_by_type' do
    subject { described_class.exporter_by_type(element_type) }

    context 'when the element type is text' do
      let(:element_type) { :text }
      it { should be ArticleJSON::Export::AppleNews::Elements::Text }
    end

    context 'when the element type is heading' do
      let(:element_type) { :heading }
      it { should be ArticleJSON::Export::AppleNews::Elements::Heading }
    end

    context 'when the element type is paragraph' do
      let(:element_type) { :paragraph }
      it { should be ArticleJSON::Export::AppleNews::Elements::Paragraph }
    end
  end

  describe '.namespace' do
    subject { described_class.namespace }
    it { should be_a Module }
    it { should eq ArticleJSON::Export::AppleNews::Elements }
  end
end
