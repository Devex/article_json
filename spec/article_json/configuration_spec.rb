describe ArticleJSON::Configuration do
  subject(:configuration) { described_class.new }

  describe 'configuration block' do
    # make sure we test with a fresh config...
    before { ArticleJSON.configuration = configuration }
    it 'should set the configuration values correctly' do
      expect { ArticleJSON.configure { |c| c.oembed_user_agent = 'foo' } }.to(
        change { ArticleJSON.configuration.oembed_user_agent }
          .from(nil)
          .to('foo')
      )
    end
  end

  describe '#oembed_user_agent' do
    subject { configuration.oembed_user_agent }

    context 'when not initialized' do
      it { should be nil }
    end

    context 'when it has a value' do
      before { configuration.oembed_user_agent = 'foo' }
      it { should eq 'foo' }
    end
  end
end
