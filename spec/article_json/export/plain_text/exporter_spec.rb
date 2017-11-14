describe ArticleJSON::Export::PlainText::Exporter do
  subject(:exporter) { described_class.new(elements) }

  describe 'reference document test' do
    subject { exporter.text }
    let(:text) { File.read('spec/fixtures/reference_document_exported.txt') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    before { stub_oembed_requests }
    it { should eq text.strip }
  end
end
