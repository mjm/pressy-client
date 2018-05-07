class Pressy::Post
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

  attr_accessor :id, :title, :content, :type, :status, :format, :published_at, :modified_at

  def initialize(params)
    @id = params["post_id"]
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

  def fields
    fields = {
      "post_title" => title,
      "post_content" => content,
      "post_type" => type,
      "post_status" => status,
      "post_format" => format,
    }
    fields["post_id"] = id if id
    fields["post_modified_gmt"] = modified_at if modified_at
    fields["post_date_gmt"] = published_at if published_at
    fields
  end

  def with(params)
    new_params = fields.merge(params)
    self.class.new(new_params)
  end

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
