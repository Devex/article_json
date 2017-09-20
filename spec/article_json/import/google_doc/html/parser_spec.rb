describe ArticleJSON::Import::GoogleDoc::HTML::Parser do
  subject(:parser) { described_class.new(html) }
  let(:html) { '' }

  context 'reference document test' do
    subject { parser.parsed_content.map(&:to_h).to_json }

    let(:html) { File.read('spec/fixtures/reference_document.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:minified_json) do
      JSON.parse(json, symbolize_names: true)[:content].to_json
    end

    it { should eq minified_json }
  end
end
