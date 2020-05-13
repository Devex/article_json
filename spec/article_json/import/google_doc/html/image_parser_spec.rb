describe ArticleJSON::Import::GoogleDoc::HTML::ImageParser do
  subject(:element) do
    described_class.new(
      node: node,
      caption_node: caption_node,
      css_analyzer: css_analyzer
    )
  end
  let(:node) do
    Nokogiri::HTML.fragment(image_fragment.strip).first_element_child
  end
  let(:caption_node) do
    Nokogiri::HTML.fragment(caption_fragment.strip).first_element_child
  end
  let(:css_analyzer) do
    ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new(css)
  end
  let(:css) { '' }
  let(:source_url) { 'foo/bar.jpg' }
  let(:image_fragment) { "<p><span><img src=\"#{source_url}\"></span></p>" }
  let(:caption_text) { 'foo' }
  let(:caption_fragment) { "<p><span>#{caption_text}</span></p>" }

  describe '#source_url' do
    subject { element.source_url }
    it { should eq source_url }
  end

  describe '#alt' do
    subject { element.alt }

    context 'whithout an alt attribute' do
      it { should eq '' }
    end

    context 'with an alt attribute' do
      let(:alt_text) { 'Alternative text' }
      let(:image_fragment) do
        "<p><span><img src=\"#{source_url}\" alt=\"#{alt_text}\"></span></p>"
      end

      it { should eq alt_text }
    end
  end

  describe '#float' do
    subject { element.float }

    let(:css) do
      <<-css
        .center { text-align: center }
        .right { text-align: right }
      css
    end
    let(:image_fragment) do
      "<p class=\"#{p_class}\"><span>#{img_tag}</span></p>"
    end

    context 'for a image without width' do
      let(:img_tag) { '<img src="foo/bar">' }

      context 'and without alignment' do
        let(:p_class) { '' }
        it { should be nil }
      end

      context 'and with right-alignment' do
        let(:p_class) { 'right' }
        it { should be nil }
      end

      context 'and with left-alignment' do
        let(:p_class) { 'center' }
        it { should be nil }
      end
    end

    context 'for a image with a width-attribute' do
      context 'and not wider than 500px' do
        let(:img_tag) { '<img width="400" src="foo/bar">' }

        context 'and without alignment' do
          let(:p_class) { '' }
          it { should be :left }
        end

        context 'and with right-alignment' do
          let(:p_class) { 'right' }
          it { should be :right }
        end

        context 'and with left-alignment' do
          let(:p_class) { 'center' }
          it { should be nil }
        end
      end

      context 'and wider than 500px' do
        let(:img_tag) { '<img width="700" src="foo/bar">' }

        context 'and without alignment' do
          let(:p_class) { '' }
          it { should be nil }
        end

        context 'and with right-alignment' do
          let(:p_class) { 'right' }
          it { should be nil }
        end

        context 'and with left-alignment' do
          let(:p_class) { 'center' }
          it { should be nil }
        end
      end
    end

    context 'for a image with a style-attribute' do
      context 'and a width wider than 500px' do
        let(:img_tag) { '<img style="width: 400px;" src="foo/bar">' }

        context 'and without alignment' do
          let(:p_class) { '' }
          it { should be :left }
        end

        context 'and with right-alignment' do
          let(:p_class) { 'right' }
          it { should be :right }
        end

        context 'and with left-alignment' do
          let(:p_class) { 'center' }
          it { should be nil }
        end
      end

      context 'and wider than 500px' do
        let(:img_tag) { '<img style="width: 700px;" src="foo/bar">' }

        context 'and without alignment' do
          let(:p_class) { '' }
          it { should be nil }
        end

        context 'and with right-alignment' do
          let(:p_class) { 'right' }
          it { should be nil }
        end

        context 'and with left-alignment' do
          let(:p_class) { 'center' }
          it { should be nil }
        end
      end
    end
  end

  describe '#caption' do
    subject { element.caption }

    it 'returns a list of text elements' do
      expect(subject).to be_an Array
      expect(subject.size).to eq 1
      expect(subject).to all be_a ArticleJSON::Elements::Text
      expect(subject.first.content).to eq 'foo'
    end

    context 'when the caption nil' do
      let(:caption_node) { nil }
      it 'returns an empty list' do
        expect(subject).to be_an Array
        expect(subject).to be_empty
      end
    end

    context 'when the caption is `[no-caption]`' do
      let(:caption_text) { '[no-caption]' }
      it 'returns an empty list' do
        expect(subject).to be_an Array
        expect(subject).to be_empty
      end
    end

    context 'when the caption is `[image-link-to]`' do
      let(:text) { 'Original caption text' }
      let(:caption_fragment) do
        "<p><span> [image-link-to: </span>" \
        "<span><a href=\"http://devex.com\">http://devex.com</a></span>" \
        "<span>] #{text}</span></p>"
      end

      it 'returns an empty list' do
        expect(subject).to be_an Array
        expect(subject.size).to eq 1
        expect(subject).to all be_a ArticleJSON::Elements::Text
        expect(subject.first.content).to eq text
      end
    end

    context 'when the caption is `[image-link-to]` and `[no-caption]`' do
      let(:caption_fragment) do
        '<p><span> [image-link-to: </span>' \
        '<span><a href="http://devex.com">http://devex.com</a></span>' \
        '<span>][no-caption]</span></p>'
      end
      it 'returns an empty list' do
        expect(subject).to be_an Array
        expect(subject).to be_empty
      end
    end
  end

  describe '#element' do
    subject { element.element }

    let(:caption_fragment) do
      '<p><span> [image-link-to: </span>' \
      '<span><a href="http://devex.com">http://devex.com</a></span>' \
      '<span>] Foo</span></p>'
    end

    it 'returns a proper Hash' do
      expect(subject).to be_a ArticleJSON::Elements::Image
      expect(subject.type).to eq :image
      expect(subject.source_url).to eq source_url
      expect(subject.float).to be nil
      expect(subject.caption).to all be_a ArticleJSON::Elements::Text
      expect(subject.href).to eq 'http://devex.com'
    end

    context 'with an image-link-to tag and a no-caption tag' do
      let(:caption_fragment) do
        '<p><span> [image-link-to: </span>' \
        '<span><a href="http://devex.com">http://devex.com</a></span>' \
        '<span>][no-caption]</span></p>'
      end
      it 'returns a proper Hash' do
        expect(subject).to be_a ArticleJSON::Elements::Image
        expect(subject.type).to eq :image
        expect(subject.source_url).to eq source_url
        expect(subject.float).to be nil
        expect(subject.caption).to be_empty
        expect(subject.href).to eq 'http://devex.com'
      end
    end
  end
end
