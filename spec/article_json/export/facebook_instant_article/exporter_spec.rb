describe ArticleJSON::Export::FacebookInstantArticle::Exporter do
  subject(:exporter) { described_class.new(elements) }

  describe 'reference document test' do
    subject { exporter.html }
    let(:html) do
      File.read('spec/fixtures/reference_document_exported.facebook.html')
    end
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    before { stub_oembed_requests }
    it { should eq html.strip }
  end

  describe '.namespace' do
    subject { described_class.namespace }
    it { should be_a Module }
    it { should eq ArticleJSON::Export::FacebookInstantArticle }
  end
end
