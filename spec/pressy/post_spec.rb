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

    fields = EXAMPLE_NORMAL_POST.merge(
      "post_modified_gmt" => Time.gm(2018, 4, 15, 22, 30, 5),
      "post_date_gmt" => Time.gm(2018, 4, 16, 12, 30, 5)
    )
    expect(post.fields).to eq fields
  end

  it "handles a post without optional fields" do
    post = Pressy::Post.new(EXAMPLE_MINIMAL_POST)
    expect(post.title).to eq ""
    expect(post.content).to eq "This post has content"
    expect(post.type).to eq "post"
    expect(post.format).to eq "status"
  end
end
