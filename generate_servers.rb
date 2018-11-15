require 'json'

def read_file(filename = "apps.json")
  file = File.read(filename)
  JSON.parse(file)
end

def urls
  data = read_file
  data.keys
end

def web_server(url_key)
  data = read_file
  name = host_name(url_key, "web")
  rng = Random.new
  env = ["Production", "Testing", "Development"]
  storage = rng.rand(10..20)
  storage_used = (storage/2).to_i
  os_names = operating_systems("web")
  os_name = os_names.keys.sample
  os_version = os_names[os_name].sample
  
  {
  "host_name" => name, 
  "description" => "This is the web server for #{data[url_key]["name"]}", 
  "fqdn" => url_key, 
  "environment" => env[rng.rand(0..2)], 
  "assigned_id" => generate_assigned_id, 
  "ram_allocated_gb" => [1,2].sample, 
  "storage_allocated_gb" => storage, 
  "storage_used_gb" => rng.rand((storage_used - 2)..(storage_used + 2)), 
  "role" => "Web Server (IIS)", 
  "cpu_count" => [1,2].sample, 
  "ram_used_gb" => 1, 
  "cpu_name" => cpu_names,
  "operating_system" => os_name, 
  "operating_system_version" => os_version, 
  "ip_addresses" => ips(3),
  "zone" => zones
  }
end

def proxy_server(url_key)
  data = read_file
  name = host_name(url_key, "proxy")
  rng = Random.new
  env = ["Production", "Testing", "Development"]
  storage = rng.rand(10..20)
  storage_used = (storage/2).to_i
  os_names = operating_systems("proxy")
  os_name = os_names.keys.sample
  os_version = os_names[os_name].sample
  
  {
  "host_name" => name, 
  "description" => "This is the reverse proxy server for #{data[url_key]["name"]}", 
  "fqdn" => url_key, 
  "environment" => env[rng.rand(0..2)], 
  "assigned_id" => generate_assigned_id, 
  "ram_allocated_gb" => [1,2].sample, 
  "storage_allocated_gb" => storage, 
  "storage_used_gb" => rng.rand((storage_used - 2)..(storage_used + 2)), 
  "role" => "Reverse Proxy Server", 
  "cpu_count" => [1,2].sample, 
  "ram_used_gb" => 1, 
  "cpu_name" => cpu_names,
  "operating_system" => os_name, 
  "operating_system_version" => os_version, 
  "ip_addresses" => ips(3),
  "zone" => zones
  }
end

def app_server(url_key)
  data = read_file
  name = host_name(url_key, "app")
  rng = Random.new
  env = ["Production", "Testing", "Development"]
  storage = rng.rand(100..400)
  storage_used = (storage/2).to_i
  os_names = operating_systems("app")
  os_name = os_names.keys.sample
  os_version = os_names[os_name].sample
  ram = [16,32,64].sample
  
  {
  "host_name" => name, 
  "description" => "This is the app server for #{data[url_key]["name"]}", 
  "fqdn" => url_key, 
  "environment" => env[rng.rand(0..2)], 
  "assigned_id" => generate_assigned_id, 
  "ram_allocated_gb" => ram, 
  "storage_allocated_gb" => storage, 
  "storage_used_gb" => rng.rand((storage_used - 20)..(storage_used + 10)), 
  "role" => "App Server", 
  "cpu_count" => [4,8].sample, 
  "ram_used_gb" => ram/2, 
  "cpu_name" => cpu_names,
  "operating_system" => os_name, 
  "operating_system_version" => os_version, 
  "ip_addresses" => ips(3),
  "zone" => zones
  }
end

def db_server(url_key)
  data = read_file
  name = host_name(url_key, "db")
  rng = Random.new
  env = ["Production", "Testing", "Development"]
  storage = rng.rand(200..500)
  storage_used = (storage/2).to_i
  os_names = operating_systems("db")
  os_name = os_names.keys.sample
  os_version = os_names[os_name].sample
  ram = [16,32,64].sample
  
  {
  "host_name" => name, 
  "description" => "This is the database server for #{data[url_key]["name"]}", 
  "fqdn" => url_key, 
  "environment" => env[rng.rand(0..2)], 
  "assigned_id" => generate_assigned_id, 
  "ram_allocated_gb" => ram, 
  "storage_allocated_gb" => storage, 
  "storage_used_gb" => rng.rand((storage_used - 2)..(storage_used + 2)), 
  "role" => "Database Server", 
  "cpu_count" => [8,16].sample, 
  "ram_used_gb" => ram/2, 
  "cpu_name" => cpu_names,
  "operating_system" => os_name, 
  "operating_system_version" => os_version, 
  "ip_addresses" => ips(3),
  "zone" => zones
  }
end

def create
  @assigned_ids = []
  all_servers = {}
  all_keys = urls
  all_keys.each do |url|
    list_of_servers = []
    list_of_servers.push(web_server(url))
    list_of_servers.push(proxy_server(url))
    list_of_servers.push(app_server(url))
    list_of_servers.push(db_server(url))
    all_servers[url] = list_of_servers
  end
  to_json_file(all_servers)
end

def to_json_file(hash_of_servers)
  File.open("servers.json","w") do |f|
    f.write(JSON.pretty_generate(hash_of_servers))
  end
end

def operating_systems(type)
  body = {
    "Red Hat Linux" => ["8.0", "9", "7.3", "7"],
    "CentOS" => ["7.3-1611", "7.4-1708", "7.5-1804"],
    "Ubuntu" => ["17.04", "17.10", "18.04", "18.10"],
    "Debian" => ["7", "8", "9"],
    "Windows Server 2003" => ["NT 5.2"],
    "windows Server 2008 R2" => ["NT 6.1"],
    "Windows Server 2016" => ["NT 10.0"]
  }
  if(type == "web" || type == "proxy")
    body["Solaris"] = ["11", "11.1", "11.2", "11.3", "11.4"]
    body["IBM AIX"] = ["7.1", "7.2"]
  end
  body
end

def cpu_names
  ["Intel 80186","Intel 80486DX","Pentium Pro","PII Xeon","PIII Xeon","Celeron","Xeon Woodcrest","Xeon Clovertown","Intel pantium M","Coppermine"].sample
end

def ips(amount, type = "public")
  ip_list = []
  rng = Random.new
  counter = 1
  while counter < amount do
    if(type == "private")
      addresses = ["10.#{rng.rand(0..255)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}", "172.#{rng.rand(16..31)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}", "192.168.#{rng.rand(0..255)}.#{rng.rand(0.255)}"]
      ip_list.push(addresses.sample)
    else
      addresses = ["#{rng.rand(1..9)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}", "#{rng.rand(11..126)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}", "#{rng.rand(198..223)}.#{rng.rand(20..255)}.#{rng.rand(0..255)}.#{rng.rand(0..255)}"]
      ip_list.push(addresses.sample)
    end
    counter += 1
  end
  ip_list
end

def zones
  cities = ["New York","Washington","Boston","Chicago","Los Angeles","San Franciso","Seattle","Dallas","Baltimore","New Delhi","Singapore","Tokyo","Hong Kong","Kyoto","New Mexico"]
  regions = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","1","2","3","4","5","6","7","8","9","10"]
  "#{cities.sample} Zone #{regions.sample}"
end

def generate_assigned_id
  rng = Random.new
  id = rng.rand(1..1000)
  counter = 0
  while @assigned_ids.include?(id) do
    id = rng.rand(1..2000)
    counter += 1
    if(counter > 150)
      break
    end
  end
  @assigned_ids.push(id)
  id
end

def host_name(url_key, type)
  prng = Random.new
  host = url_key.partition(".")[0]
  host = "#{host}#{type}#{prng.rand(0..5)}".downcase
  if(host.length > 15)
    data = read_file
    name = data[url_key]["name"].split
    host = "#{name[0]}#{type}#{prng.rand(0..5)}".downcase
    if(host.length > 15)
      host = ""
      name.each do |word|
        host = "#{host}#{word[0]}"
      end
      host = "#{host}#{type}#{prng.rand(0..5)}".downcase
    end
  end
  if(host.length > 15)
    host = "ERROR"
  end
  host
end

create