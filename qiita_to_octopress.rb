require 'open-uri'
require 'JSON'
require 'yaml'
require 'stringex'

def qiita_posts
  user_id = "your_user_id"
  qiita_api = "https://qiita.com/api/v1/users/#{user_id}/items"
  json = open(qiita_api).read
  post_jsons = JSON.parse(json)
  post_jsons.map do |post_json|
    { "title" => post_json["title"], "content" => post_json["raw_body"],
      "date" => post_json["updated_at"] }
  end
end

def read_otc_post_yaml(path)
  yaml_string = ""
  separator_count = 0
  File.open(path).each do |line|
    if line.chomp == "---"
      separator_count += 1
      next if separator_count == 1
      break if separator_count > 1
    end
    yaml_string << line
  end
  yaml_string
end

def hash_info(path)
  YAML.load(read_otc_post_yaml(path))
end

def oct_post_files
  Dir.glob("source/_posts/*.markdown")
end

def oct_post
  oct_post_files.map { |f| hash_info(f) }
end

def has_post?(title)
  oct_post.find { |post| post["title"] == title }
end

def update
  qiita_posts.each do |post|
    source_dir = "source/_posts/"
    title = post["title"]
    date = post
    if(!has_post?(title))
      puts "[NEW]   #{title}"
      write_post("#{source_dir}#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.markdown", post)
    else
      puts "[SKIP]  #{title}"
    end
  end
end

def write_post(post_path, qiita_post)
  open(post_path, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{qiita_post["title"]}\""
    post.puts "date: #{qiita_post["date"]}"
    post.puts "comments: true"
    post.puts "categories: "
    post.puts "---"
    post.puts ""
    post.puts qiita_post["content"]
  end
end

update







