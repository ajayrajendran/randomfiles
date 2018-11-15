require 'json'

def add_transition_key
  data = read_json_file
  transition_data = read_json_file("transition.json")
  new_apps = {}
  
  data.each do |name, app|
    #puts app["transition type"]
    app["transition key"] = transition_data[app["transition type"]].keys.sample
    new_apps[name] = app
  end
  
  write_json_file(new_apps)
end

def read_json_file(filename = "app_demo_data.json")
  file = File.read(filename)
  JSON.parse(file)
end

def write_json_file(new_apps)
  File.open("apps_with_key.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

add_transition_key
