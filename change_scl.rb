require 'json'

def change
  data = read_json_file
  new_apps = {}
  data.each do |name, app|
    if(app["transition type"] == "refactor" || app["transition type"] == "replatform")
      app["Source code controlled"] = true
    end
    new_apps[name] = app
  end
  write_json_file(new_apps)
end

def read_json_file
  file = File.read("app_demo_data.json")
  JSON.parse(file)
end

def write_json_file(new_apps)
  File.open("apps_scl.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

change