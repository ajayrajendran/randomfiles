require 'json'

def read_file(filename = "apps.json")
  file = File.read(filename)
  JSON.parse(file)
end

def to_json_file(file, app_list)
  File.open(file,"w") do |f|
    f.write(app_list)
  end
end

def update
  app_data = read_file("app_demo_data.json")
  new_app_data = {}
  keys_app = ["transition type", "target cloud", "transition plan complete", "transition wave", "Layer-3 Networking Only", "No Hardcoded IPs", "Web Technologies Only", "PaaS Supported Database", "Has Dockerfile"]
  
  db_data = read_file("db_demo_data.json")
  new_db_data = {}
  keys_db = "apps"
  
  app_data.each do |key, value|
    keys_app.each do |k|
      value.delete(k)
    end
    new_app_data[key] = value
  end
  
  db_data.each do |key, value|
    value.delete(keys_db)
    new_db_data[key] = value
  end
  
  to_json_file("xoxo.txt", new_app_data)
  to_json_file("xoxoxo.txt", new_db_data)
end

update