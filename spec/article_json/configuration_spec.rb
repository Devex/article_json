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
          change { ArticleJSON.configuration.html_element_exporters }
            .from({})
            .to({ foo: Object })
        )
      end
    end

    context 'when there is already an exporter registered' do
      before { configuration.html_element_exporters = { foo: Object } }
      it 'registers an additional exporter' do
        expect { subject }
          .to_not change { ArticleJSON.configuration.html_element_exporters }
      end
    end
  end

  describe '#register_element_exporters_for' do
    subject do
      ArticleJSON.configure do |c|
        c.register_element_exporters(exporter, mapping)
      end
    end
    let(:exporter) { :html }
    let(:mapping) { {} }

    context 'when passed an incorrect exporter' do
      context 'when exporter is `nil`' do
        let(:exporter) { nil }

        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError, /exporter/
        end
      end

      context 'when exporter is `:foobar`' do
        let(:exporter) { :foobar }

        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError, /exporter/
        end
      end
    end

    context 'when passed an incorrect mapping' do
      shared_examples 'for an ArgumentError due to incorrect mapping' do
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError, /type_class_mapping/
        end
      end

      context 'which has non-symbol keys' do
        let(:mapping) { { 42 => Object } }
        include_examples 'for an ArgumentError due to incorrect mapping'
      end

      context 'which has non-class values' do
        let(:mapping) { { image: 42 } }
        include_examples 'for an ArgumentError due to incorrect mapping'
      end
    end

    context 'with valid arguments' do
      let(:exporter) { :html }
      let(:mapping) { { image: Object, text: String } }
      let(:config) { ArticleJSON.configuration }

      it 'registers the correct additional exporters' do
        expect { subject }
          .to change { config.element_exporter_for(:html, :image) }.from(nil).to(Object)
          .and change { config.element_exporter_for(:html, :text) }.from(nil).to(String)
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

  describe '#html_element_exporters' do
    subject { configuration.html_element_exporters }

    context 'when not initialized' do
      it { should eq({}) }
    end

    context 'when it has a value' do
      before { configuration.html_element_exporters = { foo: 'bar' } }
      it { should eq({ foo: 'bar' }) }
    end
  end
end
