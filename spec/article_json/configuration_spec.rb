describe ArticleJSON::Configuration do
  subject(:configuration) { described_class.new }

  # make sure we test with a fresh config...
  before { ArticleJSON.configuration = configuration }

  # make sure we reset to a fresh config after all tests...
  after(:all) { ArticleJSON.configuration = ArticleJSON::Configuration.new }

  describe 'configuration block' do
    it 'should set the configuration values correctly' do
      expect { ArticleJSON.configure { |c| c.oembed_user_agent = 'foo' } }.to(
        change { ArticleJSON.configuration.oembed_user_agent }
          .from(nil)
          .to('foo')
      )
    end
  end

  describe '#register_html_element_exporter' do
    subject do
      ArticleJSON.configure do |c|
        c.register_html_element_exporter(:foo, Object)
      end
    end

    context 'when there is no exporter registered' do
      it 'registers an additional exporter' do
        expect { subject }.to(
          change { ArticleJSON.configuration.html_element_exporter }
            .from({})
            .to({ foo: Object })
        )
      end
    end

    context 'when there is already an exporter registered' do
      before { configuration.html_element_exporter = { foo: Object } }
      it 'registers an additional exporter' do
        expect { subject }
          .to_not change { ArticleJSON.configuration.html_element_exporter }
      end
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

  describe '#html_element_exporter' do
    subject { configuration.html_element_exporter }

    context 'when not initialized' do
      it { should eq({}) }
    end

    context 'when it has a value' do
      before { configuration.html_element_exporter = { foo: 'bar' } }
      it { should eq({ foo: 'bar' }) }
    end
  end
end
