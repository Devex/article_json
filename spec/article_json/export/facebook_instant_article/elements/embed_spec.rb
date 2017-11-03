describe ArticleJSON::Export::FacebookInstantArticle::Elements::Embed do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Embed.new(
      embed_type: :something,
      embed_id: 666,
      caption: [ArticleJSON::Elements::Text.new(content: 'Foo Bar')],
      tags: %w(test)
    )
  end

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }
    let(:expected_html) do
      '<figure><div class="embed">Embedded Object: something-666</div>' \
        '<figcaption>Foo Bar</figcaption></figure>'
    end
    let(:oembed_data) { { html: 'Embedded Object: something-666' } }
    before do
      allow(source_element).to receive(:oembed_data).and_return(oembed_data)
    end
    it { should eq expected_html }
  end
end
