describe ArticleJSON::Utils::AdditionalElementPlacer do
  describe '#merge_elements' do
    subject do
      described_class.new(article_elements, additional_elements).merge_elements
    end
    let(:text) { ArticleJSON::Elements::Text.new(content: 'Lorem Ipsum ') }
    let(:paragraph) { ArticleJSON::Elements::Paragraph.new(content: [text]) }
    let(:image) do
      ArticleJSON::Elements::Image.new(source_url: 'url', caption: [text])
    end
    let(:quote) do
      ArticleJSON::Elements::Quote.new(content: [paragraph], caption: [text])
    end
    let(:list) { ArticleJSON::Elements::List.new(content: [paragraph]) }
    let(:embed) do
      ArticleJSON::Elements::Embed.new(embed_type: 'youtube',
                                       embed_id: 'qwe123',
                                       caption: [text])
    end

    let(:article_elements) do
      [
        paragraph,
        image,
        image,
        paragraph,
        # Possible additional element position
        paragraph,
        # Possible additional element position
        paragraph,
        # Possible additional element position
        paragraph,
        # Possible additional element position
        paragraph,
        # Possible additional element position
        paragraph,
        quote,
        quote,
        paragraph,
        # Possible additional element position
        paragraph,
        embed,
      ]
    end

    shared_examples 'for properly added additional elements' do
      it 'should place the elements in the right position' do
        expect(subject.map(&:type)).to eq expected_article_elements.map(&:type)
      end
    end

    context 'if the article has more possible positions' do
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:element_3) { double('additional_element_3', type: :element_3) }
      let(:additional_elements) { [element_1, element_2, element_3] }

      include_examples 'for properly added additional elements' do
        let(:expected_article_elements) do
          [
            paragraph,
            image,
            image,
            paragraph,
            # Possible additional element position
            paragraph,
            element_1, # inserted element
            paragraph,
            # Possible additional element position
            paragraph,
            element_2, # inserted element
            paragraph,
            # Possible additional element position
            paragraph,
            quote,
            quote,
            paragraph,
            element_3, # inserted element
            paragraph,
            embed,
          ]
        end
      end
    end

    context 'if only one element is inserted' do
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:additional_elements) { [element_1] }

      include_examples 'for properly added additional elements' do
        let(:expected_article_elements) do
          [
            paragraph,
            image,
            image,
            paragraph,
            # Possible additional element position
            paragraph,
            # Possible additional element position
            paragraph,
            # Possible additional element position
            paragraph,
            element_1, # inserted element
            paragraph,
            # Possible additional element position
            paragraph,
            quote,
            quote,
            paragraph,
            # Possible additional element position
            paragraph,
            embed,
          ]
        end
      end
    end

    context 'if the article has just enough possible positions' do
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:element_3) { double('additional_element_3', type: :element_3) }
      let(:element_4) { double('additional_element_4', type: :element_4) }
      let(:element_5) { double('additional_element_5', type: :element_5) }
      let(:element_6) { double('additional_element_6', type: :element_6) }
      let(:additional_elements) do
        [element_1, element_2, element_3, element_4, element_5, element_6]
      end

      include_examples 'for properly added additional elements' do
        let(:expected_article_elements) do
          [
            paragraph,
            image,
            image,
            paragraph,
            element_1, # inserted element
            paragraph,
            # TODO: Leaving this empty is a known issue with the algorithm
            paragraph,
            element_2, # inserted element
            paragraph,
            element_3, # inserted element
            paragraph,
            element_4, # inserted element
            paragraph,
            quote,
            quote,
            paragraph,
            element_5, # inserted element
            paragraph,
            embed,
            element_6, # inserted element
          ]
        end
      end
    end

    context 'if the article does not have enough possible positions' do
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:element_3) { double('additional_element_3', type: :element_3) }
      let(:element_4) { double('additional_element_4', type: :element_4) }
      let(:element_5) { double('additional_element_5', type: :element_5) }
      let(:element_6) { double('additional_element_6', type: :element_6) }
      let(:element_7) { double('additional_element_7', type: :element_7) }
      let(:element_8) { double('additional_element_8', type: :element_8) }
      let(:element_9) { double('additional_element_9', type: :element_9) }
      let(:additional_elements) do
        [element_1, element_2, element_3, element_4, element_5, element_6,
         element_7, element_8, element_9]
      end

      include_examples 'for properly added additional elements' do
        let(:expected_article_elements) do
          [
            paragraph,
            image,
            image,
            paragraph,
            element_1, # inserted element
            paragraph,
            element_2, # inserted element
            paragraph,
            element_3, # inserted element
            paragraph,
            element_4, # inserted element
            paragraph,
            element_5, # inserted element
            paragraph,
            quote,
            quote,
            paragraph,
            element_6, # inserted element
            paragraph,
            embed,
            element_7, # inserted element at the end
            element_8, # inserted element at the end
            element_9, # inserted element at the end
          ]
        end
      end
    end

    context 'if the article ends with empty elements' do
      let(:additional_elements) { [] }
      let(:empty) { ArticleJSON::Elements::Paragraph.new(content: ['']) }

      include_examples 'for properly added additional elements' do
        let(:article_elements) do
          [
            paragraph,
            empty,
          ]
        end
        let(:expected_article_elements) do
          [
            paragraph,
            empty,
          ]
        end
      end
    end


    context 'when the original article only contains one element' do
      let(:text) { ArticleJSON::Elements::Text.new(content: 'Lorem Ipsum ') }
      let(:paragraph) { ArticleJSON::Elements::Paragraph.new(content: [text]) }
      let(:article_elements) { [paragraph] }
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:additional_elements) { [element_1, element_2] }
      it { should eq [*article_elements, *additional_elements] }
    end

    context 'when the original article is empty' do
      let(:article_elements) { [] }
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:additional_elements) { [element_1, element_2] }
      it { should eq additional_elements }
    end

    context 'when the original article elements are `nil`' do
      let(:article_elements) { nil }
      let(:element_1) { double('additional_element_1', type: :element_1) }
      let(:element_2) { double('additional_element_2', type: :element_2) }
      let(:additional_elements) { [element_1, element_2] }
      it { should eq additional_elements }
    end
  end
end
