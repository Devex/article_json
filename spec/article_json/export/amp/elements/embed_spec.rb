describe ArticleJSON::Export::AMP::Elements::Embed do
  subject(:element) { described_class.new(source_element) }
  let(:source_element_embed_type) { :youtube_video }
  let(:source_element_embed_id) { '666' }
  let(:source_element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: source_element_embed_type,
      embed_id: source_element_embed_id,
      caption: caption,
      tags: %w(test)
    )
  end
  let(:caption) { [ArticleJSON::Elements::Text.new(content: 'Foo Bar')] }

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    context 'with a youtube video' do
      let(:source_element_embed_type) { :youtube_video }
      let(:expected_html) do
        '<figure><div class="embed youtube-video">' \
        '<amp-youtube data-videoid="666" width="560" height="315">' \
        '</amp-youtube></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end

    context 'with a vimeo video' do
      let(:source_element_embed_type) { :vimeo_video }
      let(:expected_html) do
        '<figure><div class="embed vimeo-video">' \
        '<amp-vimeo data-videoid="666" width="560" height="315">' \
        '</amp-vimeo></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end

    context 'with a facebook video' do
      let(:url) { 'facebook.com/facebook/videos/666' }
      let(:source_element_embed_type) { :facebook_video }
      let(:expected_html) do
        '<figure><div class="embed facebook-video">' \
        '<amp-facebook ' \
        'data-embedded-as="video" ' \
        'data-href="https://www.facebook.com/Devex/videos/666" ' \
        'width="560" height="315">' \
        '</amp-facebook></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end
      let(:oembed_data) do
        JSON.parse(
          File.read('spec/fixtures/facebook_video_oembed.json'),
          symbolize_names: 1
        )
      end

      before do
        allow(source_element).to receive(:oembed_data).and_return(oembed_data)
      end

      it { should eq expected_html }
    end

    context 'with a tweet' do
      let(:source_element_embed_type) { :tweet }
      let(:source_element_embed_id) { 'myTwitterAccount/1234' }
      let(:expected_html) do
        '<figure><div class="embed tweet">' \
        '<amp-twitter data-tweetid="1234" width="560" height="315">' \
        '</amp-twitter></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end

    context 'with a slideshare presentation' do
      let(:source_element_embed_type) { :slideshare }
      let(:expected_html) do
        '<figure><div class="embed slideshare">' \
        '<amp-iframe ' \
        'src="https://www.slideshare.net/slideshow/embed_code/key/fAYvedL9rNCr9k"' \
        ' width="427" height="356" frameborder="0">' \
        '</amp-iframe></div><figcaption>Foo Bar</figcaption></figure>'
      end

      let(:oembed_data) do
        JSON.parse(
          File.read('spec/fixtures/slideshare_oembed.json'),
          symbolize_names: 1
        )
      end

      before do
        allow(source_element).to receive(:oembed_data).and_return(oembed_data)
      end
      it { should eq expected_html }
    end

    context 'with soundcloud' do
      let(:source_element_embed_type) { :soundcloud }
      let(:expected_html) do
        '<figure><div class="embed soundcloud">' \
        '<amp-soundcloud layout="fixed-height" data-trackid="392732244" ' \
        'data-visual="true" width="auto" height="315"></amp-soundcloud></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      let(:oembed_data) do
        JSON.parse(
          File.read('spec/fixtures/soundcloud_oembed.json'),
          symbolize_names: 1
        )
      end

      before do
        allow(source_element).to receive(:oembed_data).and_return(oembed_data)
      end
      it { should eq expected_html }
    end

    context 'with no caption' do
      let(:source_element_embed_type) { :youtube_video }
      let(:caption) { [] }
      let(:expected_html) do
        '<figure><div class="embed youtube-video">' \
        '<amp-youtube data-videoid="666" width="560" height="315">' \
        '</amp-youtube></div></figure>'
      end

      it { should eq expected_html }
    end
  end

  describe '#custom_element_tags' do
    subject { element.custom_element_tags }

    context 'with a youtube video' do
      let(:source_element_embed_type) { :youtube_video }
      it { should eq [:'amp-youtube'] }
    end

    context 'with a vimeo video' do
      let(:source_element_embed_type) { :vimeo_video }
      it { should eq [:'amp-vimeo'] }
    end

    context 'with a facebook video' do
      let(:source_element_embed_type) { :facebook_video }
      it { should eq [:'amp-facebook'] }
    end

    context 'with a tweet' do
      let(:source_element_embed_type) { :tweet }
      it { should eq [:'amp-twitter'] }
    end

    context 'with a slideshare presentation' do
      let(:source_element_embed_type) { :slideshare }
      it { should eq [:'amp-iframe'] }
    end

    context 'with a soundcloud' do
      let(:source_element_embed_type) { :soundcloud }
      it { should eq [:'amp-soundcloud'] }
    end

    context 'with an unknown type' do
      let(:source_element_embed_type) { :ilikecakes }
      it { should eq [] }
    end
  end
end
