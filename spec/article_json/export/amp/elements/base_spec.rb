describe ArticleJSON::Export::AMP::Elements::Base do
  subject(:element) { described_class.new(source_element) }

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    let(:sample_text) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
    let(:sample_paragraph) do
      ArticleJSON::Elements::Paragraph.new(content: [sample_text])
    end

    context 'when the source element is a text' do
      let(:source_element) { sample_text }
      it { should eq 'Foo Bar' }
    end
  end

  describe '.build' do
    subject { described_class.build(element) }

    context 'when the element type is text' do
      let(:element) { ArticleJSON::Elements::Text.new(content: '') }
      it { should be_a ArticleJSON::Export::AMP::Elements::Text }
    end
  end

  describe '.exporter_by_type' do
    subject { described_class.exporter_by_type(element_type) }

    context 'when the element type is text' do
      let(:element_type) { :text }
      it { should be ArticleJSON::Export::AMP::Elements::Text }
    end
  end
end
