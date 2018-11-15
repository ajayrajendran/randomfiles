require 'json'

def read_file(filename = "apps.json")
  file = File.read(filename)
  JSON.parse(file)
end

def update
  apps = read_file
  new_apps = {}
  databases = read_file("databases.json")
  apps.each do |name, app|
    new_apps[name] = app
    new_apps[name]["databases"] = [databases[name]["name"]]
  end
  to_json_file(new_apps)
end

def to_json_file(app_list)
  File.open("new_app.json","w") do |f|
    f.write(JSON.pretty_generate(app_list))
  end
end

update