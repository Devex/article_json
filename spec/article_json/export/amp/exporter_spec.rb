describe ArticleJSON::Export::AMP::Exporter do
  subject(:exporter) { described_class.new(elements) }

  describe 'reference document test' do
    subject { exporter.html }
    let(:html) { File.read('spec/fixtures/reference_document_exported.amp.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    before { stub_oembed_requests }
    it { should eq html.strip }
  end
end
