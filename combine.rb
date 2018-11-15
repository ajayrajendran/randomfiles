require 'json'

def read(filename = "updated.json")
  file = File.read(filename)
  JSON.parse(file)
end

def combine
  apps = read
  servers = read("servers.json")
  apps.each do |app_url, app|
    servers.each do |server_url, server_list|
      if(app_url == server_url)
        names = []
        server_list.each do |serv|
          names.push(serv["host_name"])
        end
        apps[app_url]["servers"] = names
      end
    end
  end
  to_json_file(apps)
end

def to_json_file(hash_of_apps)
  File.open("apps.json","w") do |f|
    f.write(JSON.pretty_generate(hash_of_apps))
  end
end

combine