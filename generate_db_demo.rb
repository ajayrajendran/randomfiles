require 'json'

def read_file(filename = "apps.json")
  file = File.read(filename)
  JSON.parse(file)
end

def generate_db
  types = ["Account", "Product", "App"]
  environment = ["Production", "Testing", "Development"]
  data = read_file
  servers = read_file("servers.json")
  databases = {}
  data.each do |name, app|
    rng = Random.new
    company_name = name.partition(".")[0]
    type = types.sample
    db_name = "#{company_name.capitalize} #{type} database"
    description = "This is the database for #{company_name.capitalize}'s #{type.downcase} data"
    db_server = servers[name].last
    env = environment.sample
    path = generate_path(company_name.capitalize, type, db_server["operating_system"])
    databases[name] = {
      "name": db_name,
      "description": description,
      "apps": [app["name"]],
      "environment": env,
      "database_path": path,
      "database_size": "#{rng.rand(20..60)}000",
      "cluster": db_server["host_name"]
    }
  end
  to_json_file(databases)
  puts "Finished!!!"
end

def generate_path(name, type, os)
  if os.include?("Windows")
    windows_path(name, type)
  else
    unix_path(name, type)
  end
end 

def windows_path(name, type)
  drives = ["C", "D", "E", "G"]
  "#{drives.sample}:\\Windows\\System32\\#{name.capitalize}\\databases\\#{type.downcase}_database"
end

def unix_path(name, type)
  "/usr/bin/#{name.capitalize}/app_data/databases/#{type.downcase}_database"
end

def to_json_file(db_list)
  File.open("databases.json","w") do |f|
    f.write(JSON.pretty_generate(db_list))
  end
end

generate_db
