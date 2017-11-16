describe ArticleJSON::Export::HTML::Elements::Embed do
  subject(:element) { described_class.new(source_element) }

  let(:embed_type) { :something }
  let(:source_element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: embed_type,
      embed_id: 666,
      caption: caption,
      tags: %w(test)
    )
  end
  let(:caption) { [ArticleJSON::Elements::Text.new(content: 'Foo Bar')] }

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }
    let(:oembed_data) { { html: 'Embedded Object: something-666' } }
    before do
      allow(source_element).to receive(:oembed_data).and_return(oembed_data)
    end

    context 'when the endpoint successfully returns OEmbed data' do
      context 'with a proper caption' do
        let(:expected_html) do
          '<figure><div class="embed something">' \
          'Embedded Object: something-666</div>' \
          '<figcaption>Foo Bar</figcaption></figure>'
        end
        it { should eq expected_html }
      end

      context 'without a proper caption' do
        let(:caption) { [] }
        let(:expected_html) do
          '<figure><div class="embed something">' \
          'Embedded Object: something-666</div>' \
          '</figure>'
        end
        it { should eq expected_html }
      end

      context 'when it is a facebook video' do
        let(:embed_type) { :facebook_video }
        let(:caption) { [] }
        let(:expected_html) do
          '<figure><div class="embed facebook-video">' \
          'Embedded Object: something-666</div>' \
          '</figure>'
        end
        it { should eq expected_html }
      end

      context 'when it is a vimeo video' do
        let(:embed_type) { :vimeo_video }
        let(:caption) { [] }
        let(:expected_html) do
          '<figure><div class="embed vimeo-video">' \
          'Embedded Object: something-666</div>' \
          '</figure>'
        end
        it { should eq expected_html }
      end
    end

    context 'when the endpoint does not return OEmbed data' do
      let(:embed_type) { :youtube_video }
      let(:expected_html) do
        '<figure><div class="embed youtube-video">' \
        '<span class="unavailable-embed">'\
        'The Youtube video <a href="https://www.youtube.com/watch?v=666">'\
        'https://www.youtube.com/watch?v=666</a> is not available.</span>'\
        '</div><figcaption>Foo Bar</figcaption></figure>'
      end
      let(:oembed_data) { nil }
      it { should eq expected_html }
    end
  end
end
