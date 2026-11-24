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

  describe 'articles with unavailable embeds' do
    let(:article) do
      ArticleJSON::Article.from_hash([
        { type: :paragraph, content: [{ type: :text, content: 'Before' }] },
        {
          type: :embed,
          embed_type: embed_type,
          embed_id: '666',
          caption: [{ type: :text, content: 'Embed caption' }],
          tags: []
        },
        { type: :paragraph, content: [{ type: :text, content: 'After' }] }
      ])
    end

    around do |example|
      original_token = ArticleJSON.configuration.facebook_token
      ArticleJSON.configure { |c| c.facebook_token = 'fake_facebook_token' }
      example.run
    ensure
      ArticleJSON.configure { |c| c.facebook_token = original_token }
    end

    %i(facebook_video slideshare soundcloud).each do |type|
      context "with an unavailable #{type} embed" do
        let(:embed_type) { type }

        [
          { status: 403, body: 'Forbidden' },
          { status: 404, body: 'Not found' },
          { status: 500, body: 'Server error' },
          { status: 200, body: 'Invalid JSON' }
        ].each do |response|
          it "preserves the article with a fallback after #{response}" do
            stub_request(:get, /./).to_return(response)

            html = article.to_amp
            expect(html).to eq article.to_html
            expect(html).to start_with('<p>Before</p>')
            expect(html).to end_with('<p>After</p>')
            expect(html).to include('class="unavailable-embed"')
            expect(html).to include('<figcaption>Embed caption</figcaption>')
          end
        end
      end
    end
  end

  describe '.custom_element_tags' do
    subject { exporter.custom_element_tags }

    it 'returns the right tags' do
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
        'src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>',
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
