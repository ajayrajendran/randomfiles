require 'json'

def read_json_file(filename = "app_demo_data.json")
  file = File.read(filename)
  JSON.parse(file)
end


def write_json_file(new_apps, filename)
  File.open(filename,"w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

def create
  @key_list = []
  create_app
  create_server
  create_db
  puts "finished creating the lists"
end

def create_app
  data = read_json_file
  new_list = {}
  data.first(10).to_h.each do |key, app|
    @key_list.push(key)
    new_list[key] = app
  end
  puts "there are #{new_list.keys.count} apps in the new list"
  write_json_file(new_list, "shortened_app_list.json")
end

def create_server
  data = read_json_file("server_demo_data.json")
  new_list = {}
  data.each do |key, value|
    if @key_list.include? key
      new_list[key] = value
    end
  end
  puts "there are #{new_list.keys.count} servers in the new list"
  write_json_file(new_list, "shortened_server_list.json")
end

def create_db
  data = read_json_file("db_demo_data.json")
  new_list = {}
  data.each do |key, value|
    if @key_list.include? key
      new_list[key] = value
    end
  end
  puts "there are #{new_list.keys.count} databases in the new list"
  write_json_file(new_list, "shortened_db_list.json")
end

create