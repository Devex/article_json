describe ArticleJSON::Export::AMP::Exporter do
  subject(:exporter) { described_class.new(elements) }
  let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
  let(:elements) { ArticleJSON::Article.from_json(json).elements }

  describe 'reference document test' do
    subject { exporter.html }
    let(:html) { File.read('spec/fixtures/reference_document_exported.amp.html') }

    before do
      ArticleJSON.configure { |c| c.facebook_token = 'fake_facebook_token' }
      stub_oembed_requests
    end
    
    it { should eq html.strip }
  end

  describe '.custom_element_tags' do
    subject { exporter.custom_element_tags }

    it 'should return the right tags' do
      expect(subject).to contain_exactly :'amp-vimeo',
                                         :'amp-youtube',
                                         :'amp-iframe',
                                         :'amp-twitter'
    end
  end

  describe '.amp_libraries' do
    subject { exporter.amp_libraries }

    let(:expected_result) do
      [
        '<script async custom-element="amp-vimeo" ' \
        'src="https://cdn.ampproject.org/v0/amp-vimeo-0.1.js"></script>',
        '<script async custom-element="amp-youtube" ' \
        'src="https://cdn.ampproject.org/v0/amp-youtube-0.1.js"></script>',
        '<script async custom-element="amp-iframe" ' \
        'src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>',
        '<script async custom-element="amp-twitter" ' \
        'src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>'
      ]
    end

    it { should match_array expected_result }
  end

  describe '.namespace' do
    subject { described_class.namespace }
    it { should be_a Module }
    it { should eq ArticleJSON::Export::AMP }
  end
end
