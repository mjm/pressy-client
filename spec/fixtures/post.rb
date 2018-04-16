EXAMPLE_NORMAL_POST = {
  "post_id" => 123,
  "post_title" => "This is a post",
  "post_content" => "This is my #content",
  "post_type" => "post",
  "post_format" => "standard",
  "post_modified_gmt" => XMLRPC::DateTime.new(2018, 4, 15, 22, 30, 5),
}

EXAMPLE_STATUS_POST = {
  "post_id" => 124,
  "post_title" => "",
  "post_content" => "This is a status post.",
  "post_type" => "post",
  "post_format" => "status",
  "post_modified_gmt" => XMLRPC::DateTime.new(2018, 4, 15, 22, 30, 5),
}
