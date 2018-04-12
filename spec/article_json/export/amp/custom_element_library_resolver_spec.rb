describe ArticleJSON::Export::AMP::CustomElementLibraryResolver do
  subject(:exporter) { described_class.new(tags) }
  let(:tags) { %i(amp-iframe amp-youtube) }

  describe '#sources' do
    subject { exporter.sources }

    context 'when initialized with an empty array' do
      let(:tags) { [] }
      it { should eq Hash.new }
    end

    context 'when initialized with single element' do
      let(:tags) { %i(amp-vimeo) }

      it 'should return the right script source' do
        expect(subject)
          .to eq 'amp-vimeo': 'https://cdn.ampproject.org/v0/amp-vimeo-0.1.js'
      end
    end

    context 'when initialized with multiple elements' do
      let(:tags) do
        %i(
           amp-iframe
           amp-twitter
           amp-youtube
           amp-vimeo
           amp-facebook
           amp-soundcloud
          )
      end

      it 'should return the right script tag' do
        expect(subject).to(
          eq 'amp-iframe': 'https://cdn.ampproject.org/v0/amp-iframe-0.1.js',
             'amp-twitter': 'https://cdn.ampproject.org/v0/amp-twitter-0.1.js',
             'amp-youtube': 'https://cdn.ampproject.org/v0/amp-youtube-0.1.js',
             'amp-vimeo': 'https://cdn.ampproject.org/v0/amp-vimeo-0.1.js',
             'amp-soundcloud':
                'https://cdn.ampproject.org/v0/amp-soundcloud-0.1.js',
             'amp-facebook': 'https://cdn.ampproject.org/v0/amp-facebook-0.1.js'
        )
      end
    end
  end

  describe '#script_tags' do
    subject { exporter.script_tags }

    context 'when initialized with an empty array' do
      let(:tags) { [] }

      it { should eq [] }
    end

    context 'when initialized with single element' do
      let(:tags) { %i(amp-facebook) }

      it 'should return the right script tag' do
        expect(subject).to be_an Array
        expect(subject.size).to eq 1
        expect(subject.first).to include 'amp-facebook'
        expect(subject).to(
          eq ['<script async custom-element="amp-facebook" '\
                'src="https://cdn.ampproject.org/v0/amp-facebook-0.1.js">'\
                '</script>']
        )
      end
    end

    context 'when initialized with multiple elements' do
      let(:tags) { %i(amp-facebook amp-iframe) }

      it 'should return all the right script tags' do
        expect(subject).to be_an Array
        expect(subject).to(
          match_array(
            [
              '<script async custom-element="amp-facebook" '\
                'src="https://cdn.ampproject.org/v0/amp-facebook-0.1.js">'\
                '</script>',
              '<script async custom-element="amp-iframe" '\
                'src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js">'\
                '</script>',
            ]
          )
        )
      end
    end
  end
end
