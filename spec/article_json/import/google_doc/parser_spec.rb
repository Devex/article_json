describe ArticleJSON::Import::GoogleDoc::HTML::Parser do
  subject(:parser) { described_class.new(html) }
  let(:html) { '' }

  context 'reference document test' do
    let(:html) { File.read('spec/fixtures/reference_document.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:minified_json) { JSON.parse(json).to_json }

    subject { parser.parsed_content.map(&:to_h).to_json }

    it { should eq minified_json }
  end
end
