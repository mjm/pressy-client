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

    fields = EXAMPLE_NORMAL_POST.merge("post_modified_gmt" => Time.gm(2018, 4, 15, 22, 30, 5))
    expect(post.fields).to eq fields
  end

  let(:optional_fields) { %w{post_id post_modified_gmt} }

  it "handles a post without optional fields" do
    params = EXAMPLE_NORMAL_POST.reject {|k,_| optional_fields.include? k }
    post = Wordpress::Post.new(params)
    expect(post.title).to eq "This is a post"
    expect(post.content).to eq "This is my #content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "standard"
  end
end
