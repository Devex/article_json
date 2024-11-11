describe ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer do
  subject(:parser) { described_class.new(css) }

  shared_examples_for 'a correct CSS class check' do
    context 'when passed one class which matches' do
      let(:class_str) { 'matching-class' }

      it { should be true }
    end

    context 'when passed multiple classes of which one matches' do
      let(:class_str) { 'non-matching-class matching-class' }

      it { should be true }
    end

    context 'when passed multiple classes of which *none* matches' do
      let(:class_str) { 'non-matching-class another-non-matching-class' }

      it { should be false }
    end

    context 'when passed one class which does *not* match' do
      let(:class_str) { 'non-matching-class' }

      it { should be false }
    end
  end

  describe '#bold?' do
    subject { parser.bold?(class_str) }

    context 'when the font-weight value is a string' do
      let(:css) do
        <<-CSS
          .non-matching-class { font-weight: normal }
          .matching-class { font-weight: bold }
        CSS
      end

      it_behaves_like 'a correct CSS class check'
    end

    context 'when the font-weight value is a number' do
      let(:css) do
        <<-CSS
          .non-matching-class { font-weight: 500 }
          .matching-class { font-weight: 700 }
        CSS
      end

      it_behaves_like 'a correct CSS class check'
    end
  end

  describe '#italic?' do
    subject { parser.italic?(class_str) }

    let(:css) do
      <<-CSS
        .non-matching-class { font-weight: normal }
        .matching-class { font-style: italic }
      CSS
    end

    it_behaves_like 'a correct CSS class check'
  end

  describe '#right_aligned?' do
    subject { parser.right_aligned?(class_str) }

    let(:css) do
      <<-CSS
        .non-matching-class { text-align: center }
        .matching-class { text-align: right }
      CSS
    end

    it_behaves_like 'a correct CSS class check'
  end

  describe '#left_aligned?' do
    subject { parser.left_aligned?(class_str) }

    let(:css) do
      <<-CSS
        .right { text-align: right }
        .center { text-align: center }
        .nowhere { font-style: italic }
      CSS
    end

    context 'when the node has no alignment' do
      let(:class_str) { 'nowhere' }

      it { should be true }
    end

    context 'when the node is centered' do
      let(:class_str) { 'center' }

      it { should be false }
    end

    context 'when the node is right-aligned' do
      let(:class_str) { 'right' }

      it { should be false }
    end
  end

  describe '#centered?' do
    subject { parser.centered?(class_str) }

    let(:css) do
      <<-CSS
        .non-matching-class { font-weight: bold }
        .matching-class { text-align: center }
      CSS
    end

    it_behaves_like 'a correct CSS class check'
  end
end
