describe ArticleJSON::Elements::Paragraph do
  subject(:element) { described_class.new(**params) }
  let(:params) { { content: content } }
  let(:content) { [ArticleJSON::Elements::Text.new(content: 'Foo Bar')] }
  let(:hash) { params.merge(type: :paragraph, content: content.map(&:to_h)) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '#empty?' do
    subject { element.empty? }

    context 'when `content` contains only text elements' do
      context 'when some text elements contain actual text' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: 'Lorem ipsum?'),
            ArticleJSON::Elements::Text.new(content: ' '),
          ]
        end
        it { should be false }
      end

      context 'when all text elements are blank' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: ' '),
          ]
        end
        it { should be false }
      end
    end

    context 'when `content` contains other elements' do
      let(:content) do
        [ArticleJSON::Elements::Image.new(source_url: 'foo.jpg', caption: [])]
      end
      it { should be false }
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should be true }
    end
  end

  describe '#blank?' do
    subject { element.blank? }

    context 'when `content` contains only text elements' do
      context 'when some text elements contain actual text' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: 'Lorem ipsum?'),
            ArticleJSON::Elements::Text.new(content: ' '),
          ]
        end
        it { should be false }
      end

      context 'when all text elements are blank' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: ' '),
          ]
        end
        it { should be true }
      end
    end

    context 'when `content` contains other elements' do
      let(:content) do
        [ArticleJSON::Elements::Image.new(source_url: 'foo.jpg', caption: [])]
      end
      it { should be false }
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should be true }
    end
  end

  describe '#length' do
    subject { element.length }

    context 'when `content` contains only text elements' do
      context 'when some text elements contain actual text' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: 'Lorem ipsum'),
            ArticleJSON::Elements::Text.new(content: ' sit dol'),
            ArticleJSON::Elements::Text.new(content: 'or'),
          ]
        end
        it { should eq 21 }
      end

      context 'when all text elements are blank' do
        let(:content) do
          [
            ArticleJSON::Elements::Text.new(content: ''),
            ArticleJSON::Elements::Text.new(content: ' '),
          ]
        end
        it { should eq 0 }
      end
    end

    context 'when `content` contains other elements' do
      let(:content) do
        [
          ArticleJSON::Elements::Image.new(source_url: 'foo.jpg', caption: []),
          ArticleJSON::Elements::Text.new(content: 'Lorem ipsum'),
        ]
      end
      it { should eq 11}
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should eq 0 }
    end
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::Paragraph }
    it 'has the correct values' do
      expect(subject.content).to all be_a ArticleJSON::Elements::Text
    end
  end
end
