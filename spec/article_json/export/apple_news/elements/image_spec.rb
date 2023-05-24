describe ArticleJSON::Export::AppleNews::Elements::Image do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Image.new(
      source_url: '/foo/bar.jpg',
      caption: caption,
      float: float,
      alt: alt
    )
  end
  let(:float) { nil }
  let(:caption) { [ArticleJSON::Elements::Text.new(content: 'Foo Bar')] }
  let(:alt) { 'Text description' }

  let(:expected_json) { {URL: '/foo/bar.jpg', caption: 'Foo Bar', role: 'image'} }
  
  describe '#export' do
    subject { element.export }

    context 'when the image is not floating' do
      it { should eq expected_json }
    end

    context 'when the image is floating on the left' do
      let(:float) { :left }
      it { should eq expected_json }
    end

    context 'when the image is floating on the right' do
      let(:float) { :right }
      it { should eq expected_json }
    end

    context 'when no caption is provided' do
      let(:caption) { [] }
      let(:expected_json) { {:URL=>"/foo/bar.jpg", :role=>"image"} }

      it { should eq expected_json }
    end
  end
end
