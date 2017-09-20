describe ArticleJSON::Export::HTML::Elements::Embed do
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
    it { should eq expected_html }
  end
end
