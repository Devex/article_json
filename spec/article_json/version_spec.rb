describe ArticleJSON::VERSION do
  let(:version) { ArticleJSON::VERSION }
  let(:split_version) { version.split('.') }

  it 'is a semantic version number' do
    expect(version).to be_a String
    expect(split_version.size).to be >= 3
    expect(split_version[0]).to match(/^\d+$/)
    expect(split_version[1]).to match(/^\d+$/)
    expect(split_version[2]).to match(/^\d+(-pre|-alpha|-beta)?$/)
  end
end
