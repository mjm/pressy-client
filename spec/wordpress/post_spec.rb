require 'spec_helper'

RSpec.describe Wordpress::Post do
  let(:fields) {
    {
      "post_id" => 123,
      "post_title" => "This is a post",
      "post_content" => "This is my #content",
      "post_type" => "post",
      "post_format" => "status",
    }
  }

  it "roundtrips from wordpress fields" do
    post = Wordpress::Post.new(fields)
    expect(post.id).to eq 123
    expect(post.title).to eq "This is a post"
    expect(post.content).to eq "This is my #content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "status"
    expect(post.fields).to eq fields
  end
end
