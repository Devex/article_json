describe ArticleJSON::Export::HTML::Exporter do
  subject(:exporter) { described_class.new(elements) }

  describe 'reference document test' do
    subject { exporter.html }
    let(:html) { File.read('spec/fixtures/reference_document_exported.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    it { should eq html.strip }
  end
end
