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

  describe 'amp_libraries' do
    subject { exporter.amp_libraries }

    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:elements) { ArticleJSON::Article.from_json(json).elements }
    let(:expected_result) do
      [
        '<script async custom-element="amp-vimeo"' \
        'src="https://cdn.ampproject.org/v0/amp-vimeo-0.1.js"></script>',
        '<script async custom-element="amp-youtube" ' \
        'src="https://cdn.ampproject.org/v0/amp-youtube-0.1.js"></script>',
        '<script async custom-element="amp-facebook" ' \
        'src="https://cdn.ampproject.org/v0/amp-facebook-0.1.js"></script>',
        '<script async custom-element="amp-iframe"' \
        'src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>',
        '<script async custom-element="amp-twitter" ' \
        'src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>'
      ]
    end

    before { stub_oembed_requests }

    it { should eq expected_result }
  end
end
