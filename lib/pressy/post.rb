# A Post represents a single blog post in WordPress.
# It serves as a value object for sending and receive information about blog
# posts using a {Pressy::Client}.
class Pressy::Post
  # The default set of fields to request from the WordPress API.
  WP_FIELDS = %w{
    post_id
    post_title
    post_content
    post_type
    post_status
    post_format
    post_date_gmt
    post_modified_gmt
  }

  # The ID of the post.
  # This maps to the +"post_id"+ field in the WordPress API.
  # @return [Fixnum] The ID of the post, or nil if the post is not yet saved.
  attr_accessor :id
  # The title of the post.
  # This maps to the +"post_title"+ field in the WordPress API.
  # @return [String] The title of the post, or +""+ if the post is untitled.
  attr_accessor :title
  # The body of the post.
  # This maps to the +"post_content"+ field in the WordPress API.
  # @return [String] The body of the post.
  attr_accessor :content
  # The type of "post" this represents.
  #
  # Right now, this always has the value +"post"+ because we don't support API
  # that interacts with pages.
  #
  # This maps to the +"post_type"+ field in the WordPress API.
  # @return [String] The type of the post, or +"post"+ as a default.
  attr_accessor :type
  # The publication status of the post. Posts start with a status of +"draft"+.
  #
  # This maps to the +"post_status"+ field in the WordPress API.
  # @return [String] The status of the post, or +"draft"+ as a default.
  attr_accessor :status
  # The format of the post. Not all themes use formats, but some use it to
  # indicate the sort of content that that post contains and present the post
  # differently.
  #
  # This maps to the +"post_format"+ field in the WordPress API.
  # @return [String] The format of the post.
  attr_accessor :format
  # The timestamp when the post was published, or when it is set to be
  # published.
  #
  # This maps to the +"post_date_gmt"+ field in the WordPress API.
  # @return [Time] The time when the post was or will be published.
  attr_accessor :published_at
  # The timestamp when the post was last modified.
  # This maps to the +"post_modified_gmt"+ field in the WordPress API.
  # @return [Time] The time when the post was modified.
  attr_accessor :modified_at

  # Create a new post with the given field values.
  #
  # The parameters are expected to use the same keys and types as would be
  # expected to come from the WordPress API.
  #
  # @param params [Hash<String, Object>] The field values of the post.
  def initialize(params)
    @id = params["post_id"]&.to_i
    @title = params.fetch("post_title", "")
    @content = params.fetch("post_content")
    @type = params.fetch("post_type", "post")
    @status = params.fetch("post_status", "draft")
    @format = params.fetch("post_format")
    if params["post_date_gmt"]
      @published_at = params["post_date_gmt"].to_time
    end
    if params["post_modified_gmt"]
      @modified_at = params["post_modified_gmt"].to_time
    end
  end

  # Create a [Hash] of the post data for use by the WordPress API.
  # @return [Hash<String, Object>] A hash of post data.
  def fields
    fields = {
      "post_title" => title,
      "post_content" => content,
      "post_type" => type,
      "post_status" => status,
      "post_format" => format,
    }
    fields["post_id"] = id.to_s if id
    fields["post_modified_gmt"] = modified_at if modified_at
    fields["post_date_gmt"] = published_at if published_at
    fields
  end

  # Create a new post based on this one, with some fields changed.
  # @param params [Hash<String, Object>] The field values to change.
  # @return [Pressy::Post] a new post with the updated values.
  def with(params)
    new_params = fields.merge(params)
    self.class.new(new_params)
  end

  # Compare two posts based on the contents of their fields.
  # @return [Boolean] true if the posts have all the same attributes, false otherwise.
  def ==(other)
    id == other.id &&
      title == other.title &&
      content == other.content &&
      type == other.type &&
      status == other.status &&
      format == other.format &&
      published_at == other.published_at &&
      modified_at == other.modified_at
  end
end

# {
#    "post_id"=>"506",
#    "post_title"=>"",
#    "post_date"=>#<XMLRPC::DateTime:0x007fddd31dfd68 @year=2018, @month=4, @day=6, @hour=14, @min=49, @sec=53>,
#    "post_date_gmt"=>#<XMLRPC::DateTime:0x007fddd31d7000 @year=2018, @month=4, @day=6, @hour=14, @min=49, @sec=53>,
#    "post_modified"=>#<XMLRPC::DateTime:0x007fddd31d45f8 @year=2018, @month=4, @day=6, @hour=14, @min=49, @sec=53>,
#    "post_modified_gmt"=>#<XMLRPC::DateTime:0x007fddd31cdd70 @year=2018, @month=4, @day=6, @hour=14, @min=49, @sec=53>,
#    "post_status"=>"publish",
#    "post_type"=>"post",
#    "post_name"=>"506",
#    "post_author"=>"1",
#    "post_password"=>"",
#    "post_excerpt"=>"",
#    "post_content"=>"I’ve used Vim for years, and I still don’t feel all that proficient in it. I really want to be, though: I see the potential. Anyone have suggestions for how to up my game?",
#    "post_parent"=>"0",
#    "post_mime_type"=>"",
#    "link"=>"https://mattmoriarity.com/2018/04/506/",
#    "guid"=>"https://mattmoriarity.com/?p=506",
#    "menu_order"=>0,
#    "comment_status"=>"closed",
#    "ping_status"=>"open",
#    "sticky"=>false,
#    "post_thumbnail"=>[],
#    "post_format"=>"status",
#    "terms"=>[{"term_id"=>"4", "name"=>"Status", "slug"=>"post-format-status", "term_group"=>"0", "term_taxonomy_id"=>"4", "taxonomy"=>"post_format", "description"=>"", "parent"=>"0", "count"=>157, "filter"=>"raw", "custom_fields"=>[]}, {"term_id"=>"1", "name"=>"Uncategorized", "slug"=>"uncategorized", "term_group"=>"0", "term_taxonomy_id"=>"1", "taxonomy"=>"category", "description"=>"", "parent"=>"0", "count"=>184, "filter"=>"raw", "custom_fields"=>[]}],
#    "custom_fields"=>[]
# }
