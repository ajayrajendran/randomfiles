require 'json'
require 'faker'

def read_json_file(filename = "app_demo_data.json")
  file = File.read(filename)
  JSON.parse(file)
end


def write_json_file(new_apps)
  File.open("app_with_customers.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

def add
  data = read_json_file
  new_data = {}
  data.each do |key, value|
    customer = Faker::Name.unique.name
    value["customer"] = customer
    new_data[key] = value
  end
  write_json_file(new_data)
end

add