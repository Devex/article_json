describe ArticleJSON::Export::AppleNews::Elements::Embed do
  subject(:element) { described_class.new(source_element) }
  let(:type) { :youtube_video }
  let(:embed_id) { '12345'}
  let(:caption) { [ArticleJSON::Elements::Text.new(content: caption_text)] }
  let(:caption_text) { 'Caption text' }

  let(:url) { "https://www.youtube.com/embed/#{embed_id}" }

  let(:source_element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: type,
      embed_id: embed_id,
      caption: caption,
      tags: %w[foo bar]
    )
  end

  let(:expected_json) do
    {
      URL: url,
      caption: 'Caption text',
      role: :embedwebvideo
    }
  end

  describe '#export' do
    subject { element.export }

    context 'when passed an embeded youtube video with a caption' do
      let(:expected_json) do
        [
          {
            URL: url,
            caption: caption_text,
            role: :embedwebvideo,
          },
           {
            layout: 'captionLayout',
            role: 'caption',
            text: caption_text,
            textStyle: 'captionStyle',
          },
        ]
      end
      it { should eq expected_json }
    end

    context 'when passed an embeded youtube video without a caption' do
      let(:caption) { [] }
      let(:expected_json) { {URL: url, role: :embedwebvideo} }

      it { should eq expected_json }
    end

    context 'when passed a tweet' do
      let(:type) { :tweet }
      let(:url) do
        "https://twitter.com/#{embed_id.split("/")[0]}/status/#{embed_id.split("/")[1]}"
      end
      let(:caption) { [] }
      let(:embed_id) { 'myTwitterAccount/1234' }

      let(:expected_json) { {URL: url, role: :tweet} }

      it { should eq expected_json }
    end

    context 'when passed a facebook_video' do
      let(:type) { :facebook_video }
      let(:url) do
        "https://www.facebook.com/#{embed_id.split("/")[0]}/videos/#{embed_id.split("/")[1]}"
      end
      let(:caption) { [] }
      let(:embed_id) { 'myFacebookAccount/1234' }

      let(:expected_json) { {URL: url, role: :facebook_post} }

      it { should eq expected_json }
    end

    context 'when passed a format unsupported by Apple News' do
      types = [:slideshare, :soundcloud]
      let(:expected_json) { {} }

      types.each do |type|
        let(:type) { type }
        context "when the type level is #{type}" do
          it { should eq expected_json }
        end
      end
    end
  end
end
