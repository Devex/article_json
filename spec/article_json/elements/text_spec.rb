describe ArticleJSON::Elements::Text do
  subject(:element) { described_class.new(**params) }
  let(:content) { 'Foobar' }
  let(:params) { { content: content, bold: true, italic: true, href: '/foo' } }
  let(:hash) { params.merge(type: :text) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '#empty?' do
    subject { element.empty? }

    context 'when `content` contains text' do
      let(:content) { 'Some real content' }
      it { should be false }
    end

    context 'when `content` only contains a whitespace' do
      let(:content) { ' ' }
      it { should be false }
    end

    context 'when `content` is an empty String' do
      let(:content) { '' }
      it { should be true }
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should be true }
    end
  end

  describe '#blank?' do
    subject { element.blank? }

    context 'when `content` contains text' do
      let(:content) { 'Some real content' }
      it { should be false }
    end

    context 'when `content` only contains a whitespaces' do
      let(:content) { " \t    " }
      it { should be true }
    end

    context 'when `content` is an empty String' do
      let(:content) { '' }
      it { should be true }
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should be true }
    end
  end

  describe '#length' do
    subject { element.length }

    context 'when `content` contains text' do
      let(:content) { 'Three little words' }
      it { should eq 18 }
    end

    context 'when `content` is an empty String' do
      let(:content) { '' }
      it { should eq 0 }
    end

    context 'when `content` is `nil`' do
      let(:content) { nil }
      it { should eq 0 }
    end
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::Text }
    it 'has the correct values' do
      expect(subject.content).to eq hash[:content]
      expect(subject.href).to eq hash[:href]
      expect(subject.bold).to eq hash[:bold]
      expect(subject.italic).to eq hash[:italic]
    end
  end
end
