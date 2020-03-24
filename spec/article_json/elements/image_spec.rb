describe ArticleJSON::Elements::Image do
  subject(:element) { described_class.new(**params) }
  let(:url) { 'http://devex.com' }
  let(:alt) { 'Text for the alt image attribute' }
  let(:params) do
    {
      source_url: 'foo.jpg',
      caption: [caption],
      float: :left,
      href: url,
      alt: alt
    }
  end
  let(:caption) { ArticleJSON::Elements::Text.new(content: 'Foo Bar') }
  let(:hash) { params.merge(type: :image, caption: [caption.to_h], href: url) }

  describe '#to_h' do
    subject { element.to_h }
    it { should be_a Hash }
    it { should eq hash }
  end

  describe '.parse_hash' do
    subject { described_class.parse_hash(hash) }
    it { should be_a ArticleJSON::Elements::Image }
    it 'has the correct values' do
      expect(subject.source_url).to eq hash[:source_url]
      expect(subject.float).to eq hash[:float]
      expect(subject.caption).to all be_a ArticleJSON::Elements::Text
      expect(subject.href).to eq hash[:href]
      expect(subject.alt).to eq hash[:alt]
    end
  end
end
