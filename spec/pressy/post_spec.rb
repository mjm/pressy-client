require 'spec_helper'
require 'fixtures/post'

RSpec.describe Pressy::Post do
  it "roundtrips from wordpress fields" do
    post = Pressy::Post.new(EXAMPLE_NORMAL_POST)
    expect(post.id).to eq 123
    expect(post.title).to eq "This is a post"
    expect(post.content).to eq "This is my #content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "standard"
    expect(post.published_at).to eq Time.gm(2018, 4, 16, 12, 30, 5)

    expect(post.fields).to eq EXAMPLE_NORMAL_POST
  end

  it "handles a post without optional fields" do
    post = Pressy::Post.new(EXAMPLE_MINIMAL_POST)
    expect(post.title).to eq ""
    expect(post.content).to eq "This post has content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "status"
  end

  describe "equality" do
    it "is equal to itself" do
      post = Pressy::Post.new(EXAMPLE_NORMAL_POST)
      expect(post).to eq post
    end

    it "is equal to a post from the same fields" do
      post = Pressy::Post.new(EXAMPLE_NORMAL_POST)
      post2 = Pressy::Post.new(EXAMPLE_NORMAL_POST)
      expect(post).to eq post2
    end

    it "is not equal to a different post" do
      post = Pressy::Post.new(EXAMPLE_NORMAL_POST)
      post2 = post.with("post_title" => "Foo bar")
      expect(post).not_to eq post2
    end
  end
end
