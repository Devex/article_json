describe ArticleJSON::Export::AppleNews::Exporter do
  subject(:exporter) { described_class.new(elements).to_json }

  let(:json) do
    File.read('spec/fixtures/reference_document_parsed.apple_news.json')
  end
  let(:elements) { ArticleJSON::Article.from_json(json).elements }
  let(:apple_news_doc_exported) do
    File.read('spec/fixtures/reference_document_exported.apple_news.json')
  end

  describe 'reference document test' do
    it { should eq apple_news_doc_exported }
  end
end
