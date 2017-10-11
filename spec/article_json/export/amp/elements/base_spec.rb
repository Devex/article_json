describe ArticleJSON::Export::AMP::Elements::Base do
  subject(:element) { described_class.new(source_element) }
  let(:source_element) { ArticleJSON::Elements::Text.new(content: 'Test') }

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    let(:sample_text) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

    context 'when the source element is a text' do
      let(:source_element) { sample_text }
      it { should eq 'Foo Bar' }
    end
  end

  describe '#custom_element_tags' do
    subject { element.custom_element_tags }
    it { should eq [] }
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
