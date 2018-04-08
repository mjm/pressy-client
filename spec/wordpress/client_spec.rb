require "spec_helper"
require "fixtures/post"

RSpec.describe Wordpress do
  let(:client) { double(:xmlrpc_client) }
  let(:username) { "user" }
  let(:password) { "pass" }
  let(:wordpress) { Wordpress.new(client, username, password) }

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
      Wordpress.connect(params)
    end

    it "can be created with a minimal hash of parameters" do
      params = { host: "example.com", username: username, password: password }
      expect(XMLRPC::Client).to receive(:new_from_hash).with({
        host: "example.com",
        port: 443,
        use_ssl: true,
        path: "/xmlrpc.php",
      }) { client }
      Wordpress.connect(params)
    end
  end

  it "can fetch all of the recent posts for main blog" do
    expect(client).to receive(:call).with("wp.getPosts", 1, username, password, { post_type: "post" }, Wordpress::Post::WP_FIELDS) { [EXAMPLE_NORMAL_POST, EXAMPLE_STATUS_POST] }
    posts = wordpress.posts
    expect(posts[0].id).to eq 123
    expect(posts[0].title).to eq "This is a post"
    expect(posts[1].id).to eq 124
    expect(posts[1].format).to eq "status"
  end
end
