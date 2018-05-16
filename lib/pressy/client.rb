require 'xmlrpc/client'

module Pressy
  class Client
    attr_reader :client, :username, :password

    def initialize(client, username, password)
      @client = client
      @username = username
      @password = password
    end

    def self.connect(params)
      params, username, password = connect_params(params)
      self.new(XMLRPC::Client.new_from_hash(params), username, password)
    end

    def self.connect_params(params)
      username = params.delete(:username)
      password = params.delete(:password)

      params[:path] = "/xmlrpc.php" unless params.has_key? :path
      unless params.has_key? :port
        params[:port] = 443
      end

      unless params.has_key? :use_ssl
        params[:use_ssl] = params[:port] == 443
      end

      [params, username, password]
    end

    def recent_posts
      @client.call(
        "wp.getPosts",
        1,
        @username,
        @password,
        { post_type: "post" },
        Post::WP_FIELDS
      ).map {|params| Post.new(params) }
    end

    def fetch_posts
      FetchPostsCollection.new(self)
    end

    def create_post(post)
      new_id = @client.call(
        "wp.newPost",
        1,
        @username,
        @password,
        post.fields
      )
      post.with("post_id" => new_id)
    end

    def edit_post(post)
      fields = post.fields
      fields.delete("post_id")

      @client.call(
        "wp.editPost",
        1,
        @username,
        @password,
        post.id,
        fields
      )
    end

    class FetchPostsCollection
      include Enumerable

      def initialize(wp)
        @wp = wp
      end

      def each
        offset = 0
        posts = fetch_posts(offset)

        until posts.empty?
          posts.each {|post| yield ::Pressy::Post.new(post) }
          offset += 20
          posts = fetch_posts(offset)
        end
      end

      def fetch_posts(offset=0)
        @wp.client.call(
          "wp.getPosts",
          1,
          @wp.username,
          @wp.password,
          { post_type: "post", offset: offset, number: 20 },
          ::Pressy::Post::WP_FIELDS
        )
      end
    end
  end
end

require "pressy/client/version"
require "pressy/post"
