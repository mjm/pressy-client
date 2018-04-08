require 'spec_helper'
require 'fixtures/post'

RSpec.describe Wordpress::Post do
  it "roundtrips from wordpress fields" do
    post = Wordpress::Post.new(EXAMPLE_NORMAL_POST)
    expect(post.id).to eq 123
    expect(post.title).to eq "This is a post"
    expect(post.content).to eq "This is my #content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "standard"
    expect(post.fields).to eq EXAMPLE_NORMAL_POST
  end
end
