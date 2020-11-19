require_relative 'oembed_resolver_shared'

describe ArticleJSON::Utils::OEmbedResolver::FacebookVideo do
  let(:element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: :facebook_video,
      embed_id: 1814600831891266,
      caption: []
    )
  end

  context 'when the config has the token' do
    before do
      ArticleJSON.configure { |c| c.facebook_token = 'fake_facebook_token' }
    end

    include_context 'for a successful oembed resolution' do
      let(:expected_oembed_url) do
        'https://graph.facebook.com/v9.0/oembed_video?url=' \
        'https://www.facebook.com/facebook/videos/1814600831891266' \
        '&access_token=fake_facebook_token'
      end
      let(:oembed_response) do
        File.read('spec/fixtures/facebook_video_oembed.json')
      end
      let(:expected_name) { 'Facebook video' }
    end
  end

  describe '#access_token' do
    subject { described_class.build(element).access_token }

    context 'when the config has not the token' do
      before { ArticleJSON.configure { |c| c.facebook_token = nil } }

      it 'raises an error' do
        expect { subject }.to raise_error StandardError
      end
    end

    context 'with a proper config token' do
      let(:token) { 'fake_facebook_token' }

      before { ArticleJSON.configure { |c| c.facebook_token = token } }

      it { should eq token }
    end
  end
end
