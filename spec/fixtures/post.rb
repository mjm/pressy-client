EXAMPLE_NORMAL_POST = {
  "post_id" => "123",
  "post_title" => "This is a post",
  "post_content" => "This is my #content",
  "post_type" => "post",
  "post_status" => "publish",
  "post_format" => "standard",
  "post_date_gmt" => XMLRPC::DateTime.new(2018, 4, 16, 12, 30, 5),
  "post_modified_gmt" => XMLRPC::DateTime.new(2018, 4, 15, 22, 30, 5),
}

EXAMPLE_STATUS_POST = {
  "post_id" => "124",
  "post_title" => "",
  "post_content" => "This is a status post.",
  "post_type" => "post",
  "post_status" => "draft",
  "post_format" => "status",
  "post_date_gmt" => XMLRPC::DateTime.new(2018, 4, 16, 12, 30, 5),
  "post_modified_gmt" => XMLRPC::DateTime.new(2018, 4, 15, 22, 30, 5),
}

EXAMPLE_MINIMAL_POST = {
  "post_content" => "This post has content",
  "post_format" => "status"
}

EXAMPLE_EXTRA_POST = EXAMPLE_MINIMAL_POST.merge({
  "short_url" => "http://example.com/foo"
})
