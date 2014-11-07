require 'open-uri'
require 'JSON'
require 'yaml'
require 'stringex'

def qiita_posts
  user_id = "your user id"
  qiita_api = "https://qiita.com/api/v1/users/#{user_id}/items"
  json = open(qiita_api).read
  objs = JSON.parse(json)
  posts = []
  objs.each do |post_json|
    title = post_json["title"]
    content = post_json["raw_body"]
    date = post_json["updated_at"]
    dic = {"title" => title, "content" => content, "date" => date}
    posts.push dic
  end
  posts
end

def read_yaml(path)
  yaml = ""
  cnt = 0
  File.open(path).each do |line|
    if line.chomp == "---"
      cnt = cnt + 1
      if cnt == 1
        next
      else
        break
      end
    end
    yaml = yaml + line
  end
  return yaml
end

def hash_info(path)
  yaml = read_yaml(path)
  YAML.load(yaml)
end

def post_files
  Dir.glob("source/_posts/*.markdown")
end

def oct_post
  posts = []
  post_files.each do |f|
    posts.push hash_info(f)
  end
  posts
end

def find_oct_post(title)
  oct_post.find { |post| post["title"] == title }
end

def update
  qiita_posts.each do |post|
    source_dir = "source/_posts/"
    title = post["title"]
    date = post
    if(!find_oct_post(title))
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







