require 'pressy/value'

# A Post represents a single blog post in WordPress.
# It serves as a value object for sending and receive information about blog
# posts using a {Pressy::Client}.
class Pressy::Post
  include Pressy::Value

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
  attribute :id, :post_id, from_attr: -> (id) { id.to_i }, to_attr: -> (id) { id.to_s }
  # The title of the post.
  # This maps to the +"post_title"+ field in the WordPress API.
  # @return [String] The title of the post, or +""+ if the post is untitled.
  attribute :title, :post_title, from_attr: -> (title) { title || "" }
  # The body of the post.
  # This maps to the +"post_content"+ field in the WordPress API.
  # @return [String] The body of the post.
  attribute :content, :post_content
  # The type of "post" this represents.
  #
  # Right now, this always has the value +"post"+ because we don't support API
  # that interacts with pages.
  #
  # This maps to the +"post_type"+ field in the WordPress API.
  # @return [String] The type of the post, or +"post"+ as a default.
  attribute :type, :post_type, default: "post"
  # The publication status of the post. Posts start with a status of +"draft"+.
  #
  # This maps to the +"post_status"+ field in the WordPress API.
  # @return [String] The status of the post, or +"draft"+ as a default.
  attribute :status, :post_status, default: "draft"
  # The format of the post. Not all themes use formats, but some use it to
  # indicate the sort of content that that post contains and present the post
  # differently.
  #
  # This maps to the +"post_format"+ field in the WordPress API.
  # @return [String] The format of the post.
  attribute :format, :post_format

  TIME_OPTIONS = {
    from_attr: -> (time) { time&.to_time },
  }

  # The timestamp when the post was published, or when it is set to be
  # published.
  #
  # This maps to the +"post_date_gmt"+ field in the WordPress API.
  # @return [Time] The time when the post was or will be published.
  attribute :published_at, :post_date_gmt, TIME_OPTIONS
  # The timestamp when the post was last modified.
  # This maps to the +"post_modified_gmt"+ field in the WordPress API.
  # @return [Time] The time when the post was modified.
  attribute :modified_at, :post_modified_gmt, TIME_OPTIONS

  # @!method fields
  #   Create a {Hash} of the post data for use by the WordPress API.
  #   @return [Hash<String, Object>] A hash of post data.
  alias_method :fields, :attributes
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
