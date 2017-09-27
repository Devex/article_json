shared_context 'for a successful oembed resolution' do
  subject(:resolver) { described_class.new(element) }

  describe '#oembed_url' do
    subject { resolver.oembed_url }
    it { should eq expected_oembed_url }
  end

  describe '#oembed_data' do
    subject { resolver.oembed_data }

    let(:expected_response) { JSON.parse(oembed_response, symbolize_names: 1) }

    before { stub_oembed_requests }

    context 'with no additional headers' do
      it { should eq expected_response }
    end

    context 'with additional headers' do
      before do
        ArticleJSON.configure { |c| c.oembed_user_agent = 'foobar' }
        stub_oembed_requests('User-Agent' => 'foobar')
      end
      it { should eq expected_response }
    end
  end
end
