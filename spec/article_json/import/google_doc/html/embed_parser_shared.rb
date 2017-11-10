shared_context 'for an embed parser' do
  subject(:parser) do
    described_class.new(
      node: Nokogiri::HTML.fragment(html.strip),
      caption_node:
        Nokogiri::HTML.fragment("<p><span>#{caption_text}</span></p>"),
      css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
    )
  end

  let(:caption_text) { 'Caption' }
  let(:url) { url_examples.sample }
  let(:html) do
    <<-html
      <p>
        <span>
          <a href="#{url}">#{url}</a>
          <span>&nbsp;[#{expected_tags.join(' ')}]</span>
        </span>
      </p>
    html
  end

  describe '#embed_type' do
    subject { parser.embed_type }
    it { should eq expected_embed_type }
  end

  describe '#embed_id' do
    subject { parser.embed_id }
    it { should eq expected_embed_id }

    context 'when passed a lot of different example URLs' do
      let(:node) { double('nokogiri node') }
      it 'extracts the id correctly' do
        url_examples.each do |example_url|
          allow(node).to receive(:inner_text).and_return(example_url)
          expect(subject).to eq expected_embed_id
        end
      end
    end
  end

  describe '#element' do
    subject { parser.element }
    it 'returns a proper Element' do
      expect(subject).to be_a ArticleJSON::Elements::Embed
      expect(subject.type).to eq :embed
      expect(subject.embed_type).to eq expected_embed_type
      expect(subject.embed_id).to eq expected_embed_id
      expect(subject.tags).to match_array expected_tags
      expect(subject.caption).to be_an Array
    end

    context 'when a caption is provided' do
      it 'should have the right caption defined' do
        expect(subject.caption).to be_an Array
        expect(subject.caption).to all be_a ArticleJSON::Elements::Text
        expect(subject.caption.first.content).to eq caption_text
      end
    end

    context 'when the caption is `[no-caption]`' do
      let(:caption_text) { '[no-caption]' }

      it 'should have an empty list as caption' do
        expect(subject.caption).to be_an Array
        expect(subject.caption).to be_empty
      end
    end
  end

  describe '.matches?' do
    context 'when passed a text containing a tweet URL' do
      subject { described_class.matches?(url_examples.sample) }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      subject { described_class.matches?(invalid_url_example) }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }
    it { should be_a Regexp }
    it 'matches a lot of different example URLs' do
      url_examples.each { |url| expect(subject).to match url }
    end
    it { should_not match invalid_url_example }
  end
end
