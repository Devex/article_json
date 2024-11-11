describe ArticleJSON::Export::AppleNews::Elements::TextBox do
  subject(:element) { described_class.new(source_element) }

  let(:float) { nil }
  let(:output) do
    {
      components: components,
      layout: 'textBoxLayout',
      role: 'container',
      style: 'textBoxStyle',
    }
  end

  describe '#export' do
    subject { element.export }

    context 'when the list contains regular paragraphs' do
      let(:source_element) do
        ArticleJSON::Elements::TextBox.new(
          float: float,
          tags: [],
          content: [
            ArticleJSON::Elements::Heading.new(
              content: 'A nice title for our left-aligned text box',
              level: 2
            ),
            ArticleJSON::Elements::Paragraph.new(
              content: [
                ArticleJSON::Elements::Text.new(
                  content: 'A first paragraph with some text.',
                  bold: false,
                  italic: false,
                  href: nil
                ),
              ]
            ),
            ArticleJSON::Elements::Paragraph.new(
              content: [
                ArticleJSON::Elements::Text.new(
                  content: 'Which continues here in the second paragraph.',
                  bold: false,
                  italic: false,
                  href: nil
                ),
              ]
            ),
          ]
        )
      end

      let(:components) do
        [
          {
            role: 'heading2',
            text: 'A nice title for our left-aligned text box',
            layout: 'textBoxTitleLayout',
            textStyle: 'defaultTitle',
          },
          {
            role: 'body',
            text: 'A first paragraph with some text.',
            format: 'html',
            layout: 'textBoxBodyLayout',
            textStyle: 'bodyStyle',
          },
          {
            role: 'body',
            text: 'Which continues here in the second paragraph.',
            format: 'html',
            layout: 'textBoxBodyLayout',
            textStyle: 'bodyStyle',
          },
        ]
      end

      it { should eq output }
    end

    context 'when the text box contains a list' do
      let(:source_element) do
        ArticleJSON::Elements::TextBox.new(
          float: float,
          tags: [],
          content: [
            ArticleJSON::Elements::Heading.new(
              content: 'Story Highlights',
              level: 2
            ),
            ArticleJSON::Elements::List.new(
              list_type: 'unordered',
              content: [
                ArticleJSON::Elements::Paragraph.new(
                  content: [
                    ArticleJSON::Elements::Text.new(
                      content: 'Text boxes really awesome!',
                      bold: false,
                      italic: false,
                      href: nil
                    ),
                  ]
                ),
                ArticleJSON::Elements::Paragraph.new(
                  content: [
                    ArticleJSON::Elements::Text.new(
                      content: 'They also support lists!',
                      bold: false,
                      italic: false,
                      href: nil
                    ),
                  ]
                ),
              ]
            ),
          ]
        )
      end

      let(:components) do
        [
          {
            layout: 'textBoxTitleLayout',
            role: 'heading2',
            text: 'Story Highlights',
            textStyle: 'defaultTitle',
          },
          {
            format: 'html',
            layout: 'textBoxBodyLayout',
            role: 'body',
            text: '<ul><li>Text boxes really awesome!</li><li>They also support lists!</li></ul>',
            textStyle: 'bodyStyle',
          },
        ]
      end

      it { should eq output }
    end
  end
end
