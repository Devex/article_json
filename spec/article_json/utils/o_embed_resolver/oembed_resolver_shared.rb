shared_context 'for a successful oembed resolution' do
  subject(:resolver) { described_class.new(element) }

  describe '#name' do
    subject { resolver.name }
    it { should be_a String }
    it { should eq expected_name }
  end

  describe '#oembed_url' do
    subject { resolver.oembed_url }
    it { should eq expected_oembed_url }
  end

  describe '#oembed_data' do
    subject { resolver.oembed_data }

    let(:expected_response) { JSON.parse(oembed_response, symbolize_names: 1) }

    context 'when the source responds successfully' do
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

    context 'when the source returns no body' do
      before { stub_oembed_requests(custom_body: '') }
      it { should eq nil }
    end

    context 'when the source returns an error code' do
      before { stub_oembed_requests(error: true) }
      it { should eq nil }
    end
  end

  describe '#source_url' do
    subject { resolver.source_url }
    it { should be_a String }
    it { should start_with 'http' }
  end
end
