describe ArticleJSON::Export::HTML::Exporter do
  subject(:exporter) { described_class.new(elements) }

  describe 'reference document test' do
    before do
      ArticleJSON.configure { |c| c.facebook_token = 'fake_facebook_token' }
    end
    
    subject { exporter.html }
    let(:html) { File.read('spec/fixtures/reference_document_exported.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    before { stub_oembed_requests }
    it { should eq html.strip }
  end

  describe '.namespace' do
    subject { described_class.namespace }
    it { should be_a Module }
    it { should eq ArticleJSON::Export::HTML }
  end
end
