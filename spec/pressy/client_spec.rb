require "spec_helper"
require "fixtures/post"

RSpec.describe Pressy::Client do
  let(:client) { double(:xmlrpc_client) }
  let(:username) { "user" }
  let(:password) { "pass" }
  let(:wordpress) { Pressy::Client.new(client, username, password) }
  let(:fields) { Pressy::Post::WP_FIELDS }

  it "has a version number" do
    expect(Pressy::Client::VERSION).not_to be nil
  end

  context "connecting" do
    it "can be created with a client, username, and password" do
      expect(wordpress).to_not be_nil
    end

    it "can be created with a hash of parameters" do
      params = { host: "example.com", port: 80, path: "/xmlrpc.php", username: username, password: password }
      expect(XMLRPC::Client).to receive(:new_from_hash).with({
        host: "example.com",
        port: 80,
        use_ssl: false,
        path: "/xmlrpc.php"
      }).and_return(client)
      Pressy::Client.connect(params)
    end

    it "can be created with a minimal hash of parameters" do
      params = { host: "example.com", username: username, password: password }
      expect(XMLRPC::Client).to receive(:new_from_hash).with({
        host: "example.com",
        port: 443,
        use_ssl: true,
        path: "/xmlrpc.php",
      }) { client }
      Pressy::Client.connect(params)
    end
  end

  it "can fetch all of the recent posts for main blog" do
    expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post" }, fields) { [EXAMPLE_NORMAL_POST, EXAMPLE_STATUS_POST] }
    posts = wordpress.recent_posts
    expect(posts[0].id).to eq 123
    expect(posts[0].title).to eq "This is a post"
    expect(posts[1].id).to eq 124
    expect(posts[1].format).to eq "status"
  end

  context "fetching all posts" do
    context "when there are no posts" do
      it "fetches the posts with one call" do
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 0 }, fields) { [] }
        expect(wordpress.fetch_posts.to_a).to be_empty
      end
    end

    context "when there are less than 20 posts" do
      it "fetches the posts with two calls" do
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 0 }, fields) { [EXAMPLE_NORMAL_POST] * 15 }
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 20 }, fields) { [] }
        posts = wordpress.fetch_posts.to_a
        expect(posts.count).to eq 15
        expect(posts.first).to be_a Pressy::Post
      end
    end

    context "when there are more than 20 posts" do
      it "fetches the posts with several calls" do
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 0 }, fields) { [EXAMPLE_NORMAL_POST] * 15 }
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 20 }, fields) { [EXAMPLE_STATUS_POST] * 20 }
        expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post", number: 20, offset: 40 }, fields) { [] }
        posts = wordpress.fetch_posts.to_a
        expect(posts.count).to eq 35
      end
    end
  end

  it "can create a new standard post" do
    post_content = {
      "post_title" => "Post title",
      "post_content" => "OMG this is the content",
      "post_format" => "standard",
    }
    post = Pressy::Post.new(post_content)
    post_content = post.fields
    expect(client).to receive(:call).with("wp.newPost", 1, username, password, post_content) { "1234" }
    
    post = wordpress.create_post(post)
    expect(post.fields).to eq post_content.merge("post_id" => "1234")
  end

  it "can update an existing post" do
    post = Pressy::Post.new(EXAMPLE_NORMAL_POST).with(
      "post_content" => "This is my updated content"
    )
    post_content = post.fields
    post_content.delete("post_id")
    expect(client).to receive(:call).with("wp.editPost", 1, username, password, 123, post_content) { true }

    wordpress.edit_post(post)
  end
end
