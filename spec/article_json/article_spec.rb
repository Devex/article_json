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

  shared_examples_for 'an exporter that properly handles empty articles' do
    let(:article) { described_class.new([]) }
    it { should eq '' }
  end

  describe '#html_exporter' do
    subject { article.html_exporter }
    it { should be_a ArticleJSON::Export::HTML::Exporter }
  end

  describe '#to_html' do
    subject { article.to_html }
    it { should be_a String }
    it { should eq '<p>Foo Bar</p>' }
    it_behaves_like 'an exporter that properly handles empty articles'
  end

  describe '#amp_exporter' do
    subject { article.amp_exporter }
    it { should be_a ArticleJSON::Export::AMP::Exporter }
  end

  describe '#to_amp' do
    subject { article.to_amp }
    it { should be_a String }
    it { should eq '<p>Foo Bar</p>' }
    it_behaves_like 'an exporter that properly handles empty articles'
  end

  describe '#facebook_instant_article_exporter' do
    subject { article.facebook_instant_article_exporter }
    it { should be_a ArticleJSON::Export::FacebookInstantArticle::Exporter }
  end

  describe '#to_facebook_instant_article' do
    subject { article.to_facebook_instant_article }
    it { should be_a String }
    it { should eq '<p>Foo Bar</p>' }
    it_behaves_like 'an exporter that properly handles empty articles'
  end

  describe '#plain_text_exporter' do
    subject { article.plain_text_exporter }
    it { should be_a ArticleJSON::Export::PlainText::Exporter }
  end

  describe '#to_plain_text' do
    subject { article.to_plain_text }
    it { should be_a String }
    it { should eq 'Foo Bar' }
  end

  describe '#elements' do
    subject { article.elements }

    let(:article_elements) { [paragraph, paragraph] }
    let(:article) { ArticleJSON::Article.new(article_elements) }

    context 'when additional elements have been added' do
      before { article.place_additional_elements(additional_elements) }
      let(:additional_element) do
        double('additional_element', type: :additional_element)
      end
      let(:additional_elements) { [additional_element] }

      it 'should return the merged elements' do
        expect(subject).to be_an Array
        expect(subject.map(&:type)).to eq [:paragraph,
                                           additional_element.type,
                                           :paragraph]
      end
    end

    context 'when no additional elements have been added' do
      it 'should return the original elements' do
        expect(subject).to be_an Array
        expect(subject).to eq article_elements
      end
    end
  end

  describe '#place_additional_elements' do
    subject { article.place_additional_elements(additional_elements) }

    let(:article_elements) { [paragraph, paragraph] }
    let(:article) { ArticleJSON::Article.new(article_elements) }
    let(:additional_element) do
      double('additional_element', type: :additional_element)
    end
    let(:additional_elements) { [additional_element] }

    it 'should reset the `#elements` memoization' do
      article.elements
      expect { subject }
        .to change { article.instance_variable_get(:@elements) }.to(nil)
    end

    it 'should register the additional elements' do
      expect { subject }.to change { article.additional_elements }
                              .from([])
                              .to(additional_elements)
    end

    context 'when there are already additional elements defined' do
      let(:old_additional_element) { double('old_element', type: :old_element) }
      before { article.place_additional_elements([old_additional_element]) }

      it 'should add new additional to the end' do
        expect { subject }.to change { article.additional_elements }
                                .from([old_additional_element])
                                .to([old_additional_element,
                                     additional_element])
      end
    end
  end

  shared_examples_for 'a correctly parsed Hash' do
    let(:example_hash) do
      {
        article_json_version: ArticleJSON::VERSION,
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

  shared_examples_for 'a correctly parsed empty Hash' do
    let(:example_hash) do
      { article_json_version: ArticleJSON::VERSION, content: [] }
    end
    it { should be_a described_class }
    it('contains the right content') { expect(subject.elements).to be_empty }
    it('is reversible') { expect(subject.to_h).to eq example_hash }
  end

  describe '.from_hash' do
    subject { described_class.from_hash(example_hash) }
    it_behaves_like 'a correctly parsed Hash'

    context 'when passed a list of elements instead of a hash' do
      subject { described_class.from_hash(example_hash[:content]) }
      it_behaves_like 'a correctly parsed Hash'
    end

    it_behaves_like 'a correctly parsed empty Hash'
  end

  describe '.from_json' do
    subject { described_class.from_json(example_hash.to_json) }
    it_behaves_like 'a correctly parsed Hash'
    it_behaves_like 'a correctly parsed empty Hash'
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
