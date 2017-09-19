describe ArticleJSON::Utils::OEmbedResolver::Base do
  subject(:resolver) { described_class.new(element) }

  describe '#oembed_data' do
    subject { resolver.oembed_data }

    let(:element) do
      ArticleJSON::Elements::Embed.new(
        embed_type: :something,
        embed_id: 0,
        caption: []
      )
    end
    let(:something_resolver) { double('something resolver') }
    let(:oembed_data) { { foo: :bar } }

    before do
      allow(described_class)
        .to receive(:build).with(element).and_return(something_resolver)
      allow(something_resolver)
        .to receive(:parsed_api_response).and_return(oembed_data)
    end

    it { should eq oembed_data }
  end

  describe '.build' do
    subject { described_class.build(element) }

    context 'when the element is a vimeo video' do
      let(:element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :vimeo_video,
          embed_id: 42315417,
          caption: []
        )
      end
      it { should be_a ArticleJSON::Utils::OEmbedResolver::VimeoVideo }
    end

    context 'when the element is a facebook video' do
      let(:element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :facebook_video,
          embed_id: 1814600831891266,
          caption: []
        )
      end
      it { should be_a ArticleJSON::Utils::OEmbedResolver::FacebookVideo }
    end

    context 'when the element is a youtube video' do
      let(:element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :youtube_video,
          embed_id: '_ZG8HBuDjgc',
          caption: []
        )
      end
      it { should be_a ArticleJSON::Utils::OEmbedResolver::YoutubeVideo }
    end

    context 'when the element is unknown' do
      let(:element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :foo_bar,
          embed_id: 0,
          caption: []
        )
      end
      it { should be nil }
    end
  end

  describe '.resolver_by_embed_type' do
    subject { described_class.resolver_by_embed_type(element_type) }

    context 'when the element type is facebook_video' do
      let(:element_type) { :facebook_video }
      it { should be ArticleJSON::Utils::OEmbedResolver::FacebookVideo }
    end

    context 'when the element type is vimeo_video' do
      let(:element_type) { :vimeo_video }
      it { should be ArticleJSON::Utils::OEmbedResolver::VimeoVideo }
    end

    context 'when the element type is youtube_video' do
      let(:element_type) { :youtube_video }
      it { should be ArticleJSON::Utils::OEmbedResolver::YoutubeVideo }
    end

    context 'when the element type is unknown' do
      let(:element_type) { :foo_bar }
      it { should be nil }
    end
  end
end
