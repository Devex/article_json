describe ArticleJSON::Export::PlainText::Elements::Embed do
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
    subject { element.export }
    let(:oembed_data) { { html: 'Embedded Object: something-666' } }

    context 'when the endpoint successfully returns OEmbed data' do
      context 'with a proper caption' do
        it { should eq '' }
      end

      context 'without a proper caption' do
        let(:caption) { [] }
        it { should eq '' }
      end
    end

    context 'when the endpoint does not return OEmbed data' do
      let(:embed_type) { :youtube_video }
      let(:oembed_data) { nil }
      it { should eq '' }
    end
  end
end
