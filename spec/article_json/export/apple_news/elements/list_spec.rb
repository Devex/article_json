describe ArticleJSON::Export::AppleNews::Elements::List do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::List.new(
      list_type: list_type,
      content: content
    )
  end
  let(:output) do
    {
      role: 'body',
      text: output_text,
      format: 'html',
      layout: 'bodyLayout',
      textStyle: 'bodyStyle',
    }
  end

  describe '#export' do
    subject { element.export }

    context 'when the source element is unordered' do
      let(:list_type) { :unordered }
      let(:content) do
        [
          ArticleJSON::Elements::Paragraph.new(
            {
              content: [
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'This is an unordered list...',
                    bold: false,
                    italic: false,
                    href: nil
                  }
                ),
              ]
            }
          ),
          ArticleJSON::Elements::Paragraph.new(
            {
              content: [
                ArticleJSON::Elements::Text.new(
                  {
                    content: '... with ',
                    bold: false,
                    italic: false,
                    href: nil
                  },
                ),
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'two',
                    bold: false,
                    italic: true,
                    href: nil
                  },
                ),
                ArticleJSON::Elements::Text.new(
                  {
                    content: ' entries',
                    bold: false,
                    italic: false,
                    href: nil
                  }
                ),
              ]
            }
          ),
        ]
      end
      let(:output_text) do
        "<ul><li>This is an unordered list...</li><li>... with <em>two</em> entries</li></ul>"
      end

      it { should eq output }
    end

    context 'when the source element is ordered' do
      let(:list_type) { :ordered }
      let(:content) do
        [
          ArticleJSON::Elements::Paragraph.new(
            {
              content: [
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'And here we have a numbered list',
                    bold: false,
                    italic: false,
                    href: nil
                  }
                ),
              ]
            },
          ),
          ArticleJSON::Elements::Paragraph.new(
            {
              content: [
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'This time, with ',
                    bold: false,
                    italic: false,
                    href: nil
                  },
                ),
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'three',
                    bold: false,
                    italic: true,
                    href: nil
                  },
                ),
                ArticleJSON::Elements::Text.new(
                  {
                    content: ' entries.',
                    bold: false,
                    italic: false,
                    href: nil
                  },
                ),
              ]
            },
          ),
          ArticleJSON::Elements::Paragraph.new(
            {
              content: [
                ArticleJSON::Elements::Text.new(
                  {
                    content: 'Great, innit?!',
                    bold: false,
                    italic: false,
                    href: nil
                  },
                ),
              ]
            },
          ),
        ]
      end
      let(:output_text) do
        "<ol><li>And here we have a numbered list</li><li>This time, with <em>three</em> entries.</li><li>Great, innit?!</li></ol>"
      end

      it { should eq output }
    end
  end
end
