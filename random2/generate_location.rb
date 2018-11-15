require 'json'

def add
  app_data = read_json_file
  server_data = read_json_file("server_demo_data.json")
  new_apps = {}
  app_data.each do |name, app|
    scl = []
    server = server_data[name].last
    app_name = name[0..name.index(".") - 1]
    if server["operating_system"].include?("Windows")
      scl.push(windows_path(app_name))
    else
      scl.push(unix_path(app_name))
    end
    scl.push(github(app_name))
    app["source code location"] = scl
    new_apps[name] = app
  end
  write_json_file(new_apps)
end

def windows_path(name)
  drives = ["C", "D", "E", "G"]
  "#{drives.sample}:\\Windows\\System32\\#{name}\\applications\\web_apps\\#{name}_application"
end

def unix_path(name)
  "/usr/bin/#{name}/shared/applications/web_apps/#{name}_application"
end

def github(name)
  "git@github.com:#{name}/#{name}-app.git"
end

def read_json_file(filename = "app_demo_data.json")
  file = File.read(filename)
  JSON.parse(file)
end


def write_json_file(new_apps)
  File.open("apps_with_scl_2.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

def update_location
  data = read_json_file
  new_apps = {}
  data.each do |name, app|
    if(app["Source code controlled"] == false)
      app["source code location"] = []
    end
    new_apps[name] = app
  end
  write_json_file(new_apps)
end

update_location
