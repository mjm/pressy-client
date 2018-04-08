require 'xmlrpc/client'

class Wordpress
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

  def posts
    @client.call(
      "wp.getPosts",
      1,
      @username,
      @password,
      { post_type: "post" },
      Wordpress::Post::WP_FIELDS
   ).map {|params| Wordpress::Post.new(params) }
  end
end
