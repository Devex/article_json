describe ArticleJSON::Import::GoogleDoc::HTML::Parser do
  subject(:parser) { described_class.new(html) }
  let(:html) { '' }

  context 'reference document test' do
    subject { parser.parsed_content.map(&:to_h).to_json }

    let(:html) { File.read('spec/fixtures/reference_document.html') }
    let(:json) { File.read('spec/fixtures/reference_document_parsed.json') }
    let(:minified_json) do
      JSON.parse(json, symbolize_names: true)[:content].to_json
    end

    it { should eq minified_json }

    context 'when a text box is not closed' do
      let(:html) { File.read('spec/fixtures/google_doc_unclosed_textbox.html') }
      let(:json) do
        <<-json
          {
            "article_json_version": "0.3.0",
            "content": [
              {
                "type": "text_box",
                "float": "left",
                "content": [
                  {
                    "type": "heading",
                    "level": 2,
                    "content": "Text Box without end!"
                  },
                  {
                    "type": "paragraph",
                    "content": [
                      {
                        "type": "text",
                        "content": "Lorem ipsum",
                        "bold": false,
                        "italic": false,
                        "href": null
                      }
                    ]
                  }
                ]
              }
            ]
          }
        json
      end
      it { should eq minified_json }
    end

    context 'when paragraphs contain no text' do
      let(:html) { File.read('spec/fixtures/google_doc_empty_paragraphs.html') }
      let(:json) do
        <<-json
          {
            "article_json_version": "0.3.0",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "content": "Empty paragraphs should get ignored",
                    "bold": false,
                    "italic": false,
                    "href": null
                  }  
                ]
              }
            ]
          }
        json
      end
      it { should eq minified_json }
    end
  end
end
