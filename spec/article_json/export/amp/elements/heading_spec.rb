describe ArticleJSON::Export::AMP::Elements::Heading do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Heading.new(content: 'Foo Bar', level: level)
  end

  describe '#export' do
    subject { element.export.to_html(save_with: 0) }

    (1..6).each do |i|
      context "when the heading level is #{i}" do
        let(:level) { i }
        it { should eq "<h#{level}>Foo Bar</h#{level}>" }
      end
    end
  end
end
