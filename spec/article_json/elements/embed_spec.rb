describe ArticleJSON::Elements::Embed do
  subject(:element) { described_class.new(**params) }

  let(:params) do
    {
      embed_type: :something,
      embed_id: '12345',
      caption: [caption],
      tags: %w[foo bar],
    }
  end
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
  let(:hash) { params.merge(type: :embed, caption: [caption.to_h]) }

  describe '#to_h' do
    subject { element.to_h }

    it { should be_a Hash }
    it { should eq hash }
  end

  describe '#oembed_data' do
    subject { element.oembed_data }

    let(:oembed_resolver) { double('oembed resolver') }
    let(:oembed_data) { { foo: :bar } }

    before do
      allow(oembed_resolver).to receive(:oembed_data).and_return(oembed_data)
      allow(ArticleJSON::Utils::OEmbedResolver::Base)
        .to receive(:build).and_return(oembed_resolver)
    end

    it { should eq oembed_data }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }

    it { should be_a ArticleJSON::Elements::Embed }

    it 'has the correct values' do
      expect(subject.caption).to all be_a ArticleJSON::Elements::Text
      expect(subject.embed_type).to eq hash[:embed_type]
      expect(subject.embed_id).to eq hash[:embed_id]
      expect(subject.tags).to eq hash[:tags]
    end
  end
end
