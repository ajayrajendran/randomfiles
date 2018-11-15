require 'faker'
require 'json'

def generate
  urls = File.readlines('urls')
  results = {}
  single_input = {"name" => "", "desc" => "", "urls" => [], "application owner" => "", "tech lead" => "", "value to business" => "",
  "cost hosting" => "", "number of users" => "", "staff costs" => "", "transition type" => "", "target cloud" => "", "transition plan complete" => "",
  "transition wave" => ""}
  
  transition_type = ["Replatform", "Repurchase", "Refactor", "Retire", "Rehost", "Retain"]
  target_cloud = ["AWS", "GCP", "Azure"]
  transition_plan_complete = ["yes", "no"]
  
  array_of_id = []
  num = urls.length
  (1..num).each do |b|
    if(b <= (num*30)/100)
      array_of_id.push(0)
    elsif(b <= (num*55)/100)
      array_of_id.push(1)
    elsif(b <= (num*75)/100)
      array_of_id.push(2)
    elsif(b <= (num*90)/100)
      array_of_id.push(3)
    elsif(b <= (num*99)/100)
      array_of_id.push(4)
    else
      array_of_id.push(5)
    end
  end
  array_of_id = array_of_id.shuffle
  count = 0
  
  
  urls.each do |a|
    prng = Random.new
    vtb = "#{prng.rand(13..25)}000000".to_i
    cost_hosting = "#{prng.rand(1..4)}000000".to_i
    staff_cost = "#{prng.rand(5..8)}000000".to_i
    num_users = "#{prng.rand(15..20)}0000".to_i
    owner = Faker::Name.unique.name
    lead = Faker::Name.unique.name
    
    single_input["application owner"] = owner
    single_input["tech lead"] = lead
    single_input["urls"] = [a.strip]
    single_input["value to business"] = vtb
    single_input["cost hosting"] = cost_hosting
    single_input["staff costs"] = staff_cost
    single_input["number of users"] = num_users
    single_input["transition type"] = transition_type[array_of_id[count]]
    single_input["target cloud"] = target_cloud[prng.rand(0..2)]
    single_input["transition plan complete"] = transition_plan_complete[prng.rand(0..1)]
    single_input["transition wave"] = "Move Group - #{Faker::Date.forward(365)}"
    
    temp = single_input.dup
    results[a.strip] = temp
    count += 1
  end
  write_to_json(results)
end

def write_to_json(results, filename = "demo_data_urls_2.json")
  File.open(filename,"w") do |f|
    f.write(JSON.pretty_generate(results))
  end
end

def add_on
  data = read_file
  environments = ["Production", "Testing", "Development"]
  fod = ["Hourly", "Daily", "Monthly", "Yearly"]
  uptime_req = ["9am-5pm, Mon-Fri","9am-5pm, Mon-Sat","9am-5pm, Mon-Sun","24x7"]
  data_sen = ["Low","Medium","High"]
  new_data = {}
  data.each do |key, app|
    rng = Random.new
    env_rng = rng.rand(0..2)
    fod_rng = rng.rand(0..3)
    uptime_rng = rng.rand(0..3)
    data_rng = rng.rand(0..2)
    app["environment"] = environments[env_rng]
    app["Frequency of deployments"] = fod[fod_rng]
    app["Uptime requirements"] = uptime_req[uptime_rng]
    app["Data sensitivity"] = data_sen[data_rng]
    app["Source code controlled"] = rng.rand(0..1) == 0
    app["Continuous delivery"] = rng.rand(0..1) == 0
    app["Can run on Linux"] = rng.rand(0..1) == 0
    app["Layer-3 Networking Only"] = rng.rand(0..1) == 0
    app["No Hardcoded IPs"] = rng.rand(0..1) == 0
    app["Web Technologies Only"] = rng.rand(0..1) == 0
    app["PaaS Supported Database"] = rng.rand(0..1) == 0
    app["Has Dockerfile"] = rng.rand(0..1) == 0
    app["PII"] = rng.rand(0..1) == 0
    app["Legal holds"] = rng.rand(0..1) == 0
    app["COTS"] = rng.rand(0..1) == 0
    app["Business continuity plan"] = rng.rand(0..1) == 0
    app["End of support date"] = Faker::Date.between("06/01/2019", "06/01/2024")
    new_data[key] = app
  end
  puts new_data.length
  write_to_json(new_data, "new_data.json")
end

def read_file(filename = 'demo_data_urls.json')
  file = File.read(filename)
  JSON.parse(file)
end

def update_move_groups
  data = read_file
  move_group_dates = []
  (0..4).each do |a|
    move_group_dates.push("Move Group -  #{Faker::Date.forward(365)}")
  end
  move_group_ids = []
  move_group_ids.fill(0, 0..9)
  move_group_ids.fill(1, 10..19)
  move_group_ids.fill(2, 20..29)
  move_group_ids.fill(3, 30..39)
  move_group_ids.fill(4, 40..49)
  move_group_ids = move_group_ids.shuffle
  
  update_hash = {}
  counter = 0
  data.each do |key, value|
    value["transition wave"] = move_group_dates[move_group_ids[counter]]
    update_hash[key] = value
    counter += 1
  end
  data.update(update_hash)
  write_to_json(data, "updated.json")
end

data = read_file('updated.json')
my_array = []
data.each do |key, val|
  my_array.push(val["transition wave"]) unless my_array.include?(val["transition wave"])
end
puts my_array.to_s