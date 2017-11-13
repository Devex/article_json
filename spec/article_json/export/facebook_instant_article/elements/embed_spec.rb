describe ArticleJSON::Export::FacebookInstantArticle::Elements::Embed do
  subject(:element) { described_class.new(source_element) }
  let(:type) { :youtube_video }

  let(:source_element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: type,
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

    context 'when the element it is not a facebook video nor a tweet' do
      context 'with a proper caption' do
        let(:expected_html) do
          '<figure class="op-interactive">Embedded Object: something-666' \
          '<figcaption>Foo Bar</figcaption></figure>'
        end

        it { should eq expected_html }
      end

      context 'without a proper caption' do
        let(:caption) { [] }
        let(:expected_html) do
          '<figure class="op-interactive">Embedded Object: something-666' \
          '</figure>'
        end

        it { should eq expected_html }
      end
    end

    context 'with a tweet' do
      let(:type) { :tweet }
      let(:expected_html) do
        '<figure class="op-interactive">' \
        '<iframe>Embedded Object: something-666</iframe>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end

    context 'with a facebook video' do
      let(:type) { :facebook_video }
      let(:expected_html) do
        '<figure class="op-interactive">' \
        '<iframe>Embedded Object: something-666</iframe>' \
        '<figcaption>Foo Bar</figcaption></figure>'
      end

      it { should eq expected_html }
    end
  end
end
