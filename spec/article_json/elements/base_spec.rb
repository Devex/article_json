describe ArticleJSON::Elements::Base do
  let(:text_hash) do
    { type: :text, content: 'Foobar', bold: true, italic: true, href: '/foo' }
  end
  let(:heading_hash) { { type: :heading, level: 42, content: 'Foobar' } }
  let(:paragraph_hash) { { type: :paragraph, content: [text_hash] } }
  let(:list_hash) do
    { type: :list, content: [paragraph_hash], list_type: :ordered }
  end
  let(:image_hash) { { type: :image, caption: [text_hash], float: :right } }
  let(:text_box_hash) do
    { type: :text_box, content: [paragraph_hash], float: :right }
  end
  let(:quote_hash) do
    {
      type: :quote,
      content: [paragraph_hash],
      caption: [text_hash],
      float: :left,
    }
  end
  let(:embed_hash) do
    {
      type: :embed,
      embed_type: :something,
      embed_id: '666',
      caption: [text_hash],
      tags: %w[foo bar],
    }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }

    context 'when the hash is a text' do
      let(:hash) { text_hash }

      it { should be_a ArticleJSON::Elements::Text }
    end

    context 'when the hash is a heading' do
      let(:hash) { heading_hash }

      it { should be_a ArticleJSON::Elements::Heading }
    end

    context 'when the hash is a paragraph' do
      let(:hash) { paragraph_hash }

      it { should be_a ArticleJSON::Elements::Paragraph }
    end

    context 'when the hash is a list' do
      let(:hash) { list_hash }

      it { should be_a ArticleJSON::Elements::List }
    end

    context 'when the hash is a image' do
      let(:hash) { image_hash }

      it { should be_a ArticleJSON::Elements::Image }
    end

    context 'when the hash is a text box' do
      let(:hash) { text_box_hash }

      it { should be_a ArticleJSON::Elements::TextBox }
    end

    context 'when the hash is a quote' do
      let(:hash) { quote_hash }

      it { should be_a ArticleJSON::Elements::Quote }
    end

    context 'when the hash is a embed' do
      let(:hash) { embed_hash }

      it { should be_a ArticleJSON::Elements::Embed }
    end
  end

  describe '.parse_hash_list' do
    subject { described_class.parse_hash_list(list) }

    let(:list) do
      [
        text_hash,
        heading_hash,
        paragraph_hash,
        list_hash,
        image_hash,
        text_box_hash,
        quote_hash,
        embed_hash,
      ]
    end

    it { should be_an Array }

    it 'has the correct elements' do
      expect(subject[0]).to be_a ArticleJSON::Elements::Text
      expect(subject[1]).to be_a ArticleJSON::Elements::Heading
      expect(subject[2]).to be_a ArticleJSON::Elements::Paragraph
      expect(subject[3]).to be_a ArticleJSON::Elements::List
      expect(subject[4]).to be_a ArticleJSON::Elements::Image
      expect(subject[5]).to be_a ArticleJSON::Elements::TextBox
      expect(subject[6]).to be_a ArticleJSON::Elements::Quote
      expect(subject[7]).to be_a ArticleJSON::Elements::Embed
    end
  end

  describe 'reference document test' do
    subject { elements.map(&:to_h).to_json }

    let(:elements) { described_class.parse_hash_list(parsed_json[:content]) }
    let(:parsed_json) { JSON.parse(json, symbolize_names: true) }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }

    it { should eq parsed_json[:content].to_json }
  end
end
