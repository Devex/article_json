describe ArticleJSON::Export::AppleNews::Elements::Heading do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Heading.new(content: 'Foo Bar', level: level)
  end

  describe '#export' do
    subject { element.export }

    (1..6).each do |i|
      context "when the heading level is #{i}" do
        let(:level) { i }
        let(:heading) do
          {
            role: "heading#{i}",
            text: 'Foo Bar',
            layout: 'titleLayout',
            textStyle: 'defaultTitle',
          }
        end
        it { should eq heading }
      end
    end
  end
end
