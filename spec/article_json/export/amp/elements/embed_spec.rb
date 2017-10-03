describe ArticleJSON::Export::AMP::Elements::Embed do
  subject(:element) { described_class.new(source_element) }

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    context 'with a youtube video' do
      let(:source_element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :youtube_video,
          embed_id: 666,
          caption: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')],
          tags: %w(test)
        )
      end
      let(:expected_html) do
        '<figure><div class="embed">' \
        '<amp-youtube data-videoid="666" width="560" height="315">' \
        '</amp-youtube></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end

    context 'with a vimeo video' do
      let(:source_element) do
        ArticleJSON::Elements::Embed.new(
          embed_type: :vimeo_video,
          embed_id: 666,
          caption: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')],
          tags: %w(test)
        )
      end
      let(:expected_html) do
        '<figure><div class="embed">' \
        '<amp-vimeo data-videoid="666" width="560" height="315">' \
        '</amp-vimeo></div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end
  end
end
