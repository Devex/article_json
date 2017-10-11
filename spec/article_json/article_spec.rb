describe ArticleJSON::Article do
  subject(:article) { described_class.new([paragraph]) }

  let(:paragraph) { ArticleJSON::Elements::Paragraph.new(content: [text]) }
  let(:text) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }

  describe '#to_h' do
    subject { article.to_h }
    it { should be_a Hash }
    it { should have_key :article_json_version }
    it { should have_key :content }
    it 'should contain the right content' do
      expect(subject[:content]).to contain_exactly paragraph.to_h
    end
  end

  describe '#to_json' do
    subject { article.to_json }

    let(:parsed_json) { JSON.parse(subject, symbolize_names: true) }
    let(:parsed_content) do
      ArticleJSON::Elements::Base.parse_hash_list(parsed_json[:content])
    end

    it { should be_a String }
    it 'should contain the right content' do
      expect(parsed_json).to be_a Hash
      expect(parsed_json).to have_key :article_json_version
      expect(parsed_json).to have_key :content
      expect(parsed_content).to all be_a ArticleJSON::Elements::Paragraph
    end
  end

  describe '#html_exporter' do
    subject { article.html_exporter }
    it { should be_a ArticleJSON::Export::HTML::Exporter }
  end

  describe '#to_html' do
    subject { article.to_html }
    it { should be_a String }
    it { should eq '<p>Foo Bar</p>' }
  end

  shared_context 'for a correctly parsed Hash' do
    let(:example_hash) do
      {
        article_json_version: '0.1.0',
        content: [
          {
            type: :paragraph,
            content: [
              {
                type: :text,
                content: 'Foo Bar',
                bold: nil,
                italic: nil,
                href: nil
              },
            ],
          },
        ],
      }
    end
    it { should be_a described_class }
    it 'contains the right content' do
      expect(subject.elements).to all be_a ArticleJSON::Elements::Paragraph
    end
    it('is reversible') { expect(subject.to_h).to eq example_hash }
  end

  describe '.from_hash' do
    subject { described_class.from_hash(example_hash) }
    include_context 'for a correctly parsed Hash'

    context 'when passed a list of elements instead of a hash' do
      subject { described_class.from_hash(example_hash[:content]) }
      include_context 'for a correctly parsed Hash'
    end
  end

  describe '.from_json' do
    subject { described_class.from_json(example_hash.to_json) }
    include_context 'for a correctly parsed Hash'
  end

  describe '.from_google_doc_html' do
    subject { described_class.from_google_doc_html(html) }
    let(:html) { File.read('spec/fixtures/reference_document.html') }
    it { should be_a described_class }
    it 'contains the right content' do
      expect(subject.elements).to all be_a ArticleJSON::Elements::Base
    end
  end
end
