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

  describe '#register_element_exporters' do
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

  describe '#element_exporter_for' do
    subject { configuration.element_exporter_for(exporter_type, element_type) }
    let(:exporter_type) { :my_exporter }
    let(:element_type) { :my_element }
    let(:custom_exporters) { {} }

    before do
      configuration.instance_variable_set(:@custom_element_exporters,
                                          custom_exporters)
    end

    context 'when the exporter type is not initialized' do
      it { should be nil }
    end

    context 'when the exporter type is initialized' do
      let(:custom_exporters_for_type) { {} }
      let(:custom_exporters) { { exporter_type => custom_exporters_for_type } }

      context 'but there is no exporter for the element type' do
        it { should be nil }
      end

      context 'and there is an exporter for the element type' do
        let(:custom_exporter_for_element) { double('custom_exporter') }
        let(:custom_exporters_for_type) do
          { element_type => custom_exporter_for_element }
        end
        it { should eq custom_exporter_for_element }
      end
    end

    context 'when it has a value' do

    end
  end
end
