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
      posts = call "wp.getPosts", { post_type: "post" }, Post::WP_FIELDS
      posts.map {|params| Post.new(params) }
    end

    def fetch_posts
      FetchPostsCollection.new(self)
    end

    def fetch_post(id)
      fields = call "wp.getPost", id.to_i, Post::WP_FIELDS
      Post.new(fields)
    end

    def create_post(post)
      new_id = call "wp.newPost", post.fields
      fetch_post(new_id)
    end

    def edit_post(post)
      fields = post.fields
      fields.delete("post_id")

      call "wp.editPost", post.id, fields
      fetch_post(post.id)
    end

    def call(method, *args)
      @client.call(method, 1, @username, @password, *args)
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
          posts.each {|post| yield Post.new(post) }
          offset += 20
          posts = fetch_posts(offset)
        end
      end

      def fetch_posts(offset=0)
        @wp.call "wp.getPosts", { post_type: "post", offset: offset, number: 20 }, Post::WP_FIELDS
      end
    end
  end
end

require "pressy/client/version"
require "pressy/post"
