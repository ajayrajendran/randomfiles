require 'json'
require 'faker'

def generate
  app_names = {
    "Payment Integration App": "Stripe API",
    "Map Integration App": "Google Maps API",
    "Custom Search Integration App": "Google Search API",
    "Ads Payment Integration App": "Google Ads API",
    "Custom Tweet Filter App": "Twitter API",
    "External Login Integration App": "Stormpath API",
    "Email Login Integration App": "FullContact API",
    "Marketing Email Automation App": "MailChimp API"
  }
  
  transition_type = ["Replatform", "Repurchase", "Refactor", "Retire", "Rehost", "Retain"]
  target_cloud = ["AWS", "GCP", "Azure"]
  transition_plan_complete = ["yes", "no"]
  environments = ["Production", "Testing", "Development"]
  fod = ["Hourly", "Daily", "Monthly", "Yearly"]
  uptime_req = ["9am-5pm, Mon-Fri","9am-5pm, Mon-Sat","9am-5pm, Mon-Sun","24x7"]
  data_sen = ["Low","Medium","High"]
  
  content = {}
  single_input = {}
  count = 0
  
  servers = generate_servers
  server_names = []
  servers.each do |code, info|
    content[info["host_name"]] = info
    server_names.push(info["host_name"])
  end
  
  app_names.each do |name, dependencies|
    rng = Random.new
    vtb = "#{rng.rand(13..25)}000000".to_i
    cost_hosting = "#{rng.rand(1..4)}000000".to_i
    staff_cost = "#{rng.rand(5..8)}000000".to_i
    num_users = "#{rng.rand(15..20)}0000".to_i
    owner = Faker::Name.unique.name
    lead = Faker::Name.unique.name
    env_rng = rng.rand(0..2)
    fod_rng = rng.rand(0..3)
    uptime_rng = rng.rand(0..3)
    data_rng = rng.rand(0..2)
    count += 1
    
    single_input["application owner"] = owner
    single_input["tech lead"] = lead
    single_input["value to business"] = vtb
    single_input["cost hosting"] = cost_hosting
    single_input["staff costs"] = staff_cost
    single_input["number of users"] = num_users
    single_input["transition type"] = transition_type.sample
    single_input["target cloud"] = target_cloud[rng.rand(0..2)]
    single_input["transition plan complete"] = transition_plan_complete[rng.rand(0..1)]
    single_input["transition wave"] = "Move Group - #{Faker::Date.forward(365)}"
    single_input["dependencies"] = dependencies
    single_input["environment"] = environments[env_rng]
    single_input["Frequency of deployments"] = fod[fod_rng]
    single_input["Uptime requirements"] = uptime_req[uptime_rng]
    single_input["Data sensitivity"] = data_sen[data_rng]
    single_input["Source code controlled"] = rng.rand(0..1) == 0
    single_input["Continuous delivery"] = rng.rand(0..1) == 0
    single_input["Can run on Linux"] = rng.rand(0..1) == 0
    single_input["Layer-3 Networking Only"] = rng.rand(0..1) == 0
    single_input["No Hardcoded IPs"] = rng.rand(0..1) == 0
    single_input["Web Technologies Only"] = rng.rand(0..1) == 0
    single_input["PaaS Supported Database"] = rng.rand(0..1) == 0
    single_input["Has Dockerfile"] = rng.rand(0..1) == 0
    single_input["PII"] = rng.rand(0..1) == 0
    single_input["Legal holds"] = rng.rand(0..1) == 0
    single_input["COTS"] = rng.rand(0..1) == 0
    single_input["Business continuity plan"] = rng.rand(0..1) == 0
    single_input["End of support date"] = Faker::Date.between("06/01/2019", "06/01/2024")
    
    if(count <= 4)
      single_input["servers"] = [server_names[0]]
    else
      single_input["servers"] = [server_names[1]]
    end
    temp = single_input.dup
    content[name] = temp
  end
  write_to_json(content)
end

def generate_servers
  servers = {}
  (1..2).each do |num|
    servers["server#{num}"] = app_server(num)
  end
  servers
end

def app_server(num)
  name = "dependencyapp0#{num}"
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
  "description" => "This is the app server for internal app dependencies",
  "environment" => env[rng.rand(0..2)], 
  "assigned_id" => 2000 + num, 
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

def cpu_names
  ["Intel 80186","Intel 80486DX","Pentium Pro","PII Xeon","PIII Xeon","Celeron","Xeon Woodcrest","Xeon Clovertown","Intel pantium M","Coppermine"].sample
end

def zones
  cities = ["New York","Washington","Boston","Chicago","Los Angeles","San Franciso","Seattle","Dallas","Baltimore","New Delhi","Singapore","Tokyo","Hong Kong","Kyoto","New Mexico"]
  regions = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","1","2","3","4","5","6","7","8","9","10"]
  "#{cities.sample} Zone #{regions.sample}"
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

def ips(amount, type = "private")
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

def write_to_json(results, filename = "dependency_apps.json")
  File.open(filename,"w") do |f|
    f.write(JSON.pretty_generate(results))
  end
end

generate
