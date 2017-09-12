describe ArticleJSON::Import::GoogleDoc::HTML::EmbeddedTweetElement do
  subject(:element) do
    described_class.new(
      node: node,
      caption_node: caption_node,
      css_analyzer: ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer.new
    )
  end

  let(:node) { Nokogiri::XML.fragment(html.strip) }
  let(:html) do
    <<-html
      <p>
        <span>
          <a href="https://twitter.com/d3v3x/status/#{tweet_id}">
            https://twitter.com/d3v3x/status/#{tweet_id}
          </a>
          <span>&nbsp;[twitter test]</span>
        </span>
      </p>
    html
  end

  let(:caption_node) { Nokogiri::XML.fragment(caption_html.strip) }
  let(:caption_html) { '<p><span>Caption</span></p>' }
  let(:tweet_id) { '55460863903059968' }
  let(:url_examples) do
    %W(
      twitter.com/d3v3x/status/#{tweet_id}
      http://twitter.com/d3v3x/status/#{tweet_id}
      https://twitter.com/d3v3x/status/#{tweet_id}
      www.twitter.com/d3v3x/status/#{tweet_id}
      http://www.twitter.com/d3v3x/status/#{tweet_id}
      https://www.twitter.com/d3v3x/status/#{tweet_id}

      twitter.com/d3v3x/statuses/#{tweet_id}
      http://twitter.com/d3v3x/statuses/#{tweet_id}
      https://twitter.com/d3v3x/statuses/#{tweet_id}
      www.twitter.com/d3v3x/statuses/#{tweet_id}
      http://www.twitter.com/d3v3x/statuses/#{tweet_id}
      https://www.twitter.com/d3v3x/statuses/#{tweet_id}

      twitter.com/d3v3x##{tweet_id}
      http://twitter.com/d3v3x##{tweet_id}
      https://twitter.com/d3v3x##{tweet_id}
      www.twitter.com/d3v3x##{tweet_id}
      http://www.twitter.com/d3v3x##{tweet_id}
      https://www.twitter.com/d3v3x##{tweet_id}
    )
  end

  describe '#embed_type' do
    subject { element.embed_type }
    it { should eq :tweet }
  end

  describe '#embed_id' do
    subject { element.embed_id }
    it { should eq "d3v3x/#{tweet_id}" }
  end

  describe 'to_h' do
    subject { element.to_h }

    it 'returns a proper Hash' do
      expect(subject).to be_a Hash
      expect(subject[:type]).to eq :embed
      expect(subject[:embed_type]).to eq :tweet
      expect(subject[:embed_id]).to eq "d3v3x/#{tweet_id}"
      expect(subject[:tags]).to match_array %w(twitter test)
      expect(subject[:caption].first[:content]).to eq 'Caption'
    end
  end

  describe '.matches?' do
    subject { described_class.matches?(url) }

    context 'when passed a text containing a tweet URL' do
      let(:url) { url_examples.sample }
      it { should be true }
    end

    context 'when passed a text containing another URL' do
      let(:url) { 'https://www.devex.com/news/twitter-tweets-r-fun-123' }
      it { should be false }
    end
  end

  describe '.url_regexp' do
    subject { described_class.url_regexp }

    it { should be_a Regexp }
    it 'matches a lot of different Twitter URLs' do
      url_examples.each { |url| expect(subject).to match url }
    end
  end
end
