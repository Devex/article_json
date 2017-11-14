describe ArticleJSON::Export::PlainText::Elements::Heading do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Heading.new(content: 'Foo Bar', level: level)
  end

  describe '#export' do
    subject { element.export }

    context 'when the heading level is 1' do
      let(:level) { 1 }
      it { should eq "\n\n\nFoo Bar\n\n" }
    end

    context 'when the heading level is 2' do
      let(:level) { 2 }
      it { should eq "\n\nFoo Bar\n\n" }
    end

    (3..6).each do |i|
      context "when the heading level is #{i}" do
        let(:level) { i }
        it { should eq "\nFoo Bar\n\n" }
      end
    end
  end
end
