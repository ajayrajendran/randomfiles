require 'json'

@cast_ids = []

def app_cast
  data = read_json_file
  new_app = {}
  data.each do |name, app|
    opts = generate_data
    opts.each do |key, value|
      app[key] = value
    end
    new_app[name] = app
  end
  write_json_file(new_app)
end

def generate_data
  rng = Random.new
  readiness = rng.rand(0.1..0.9)
  opts = randomizers(readiness, rng)
  opts["paas_readiness"] = readiness
  opts["cast_id"] = cast_id(rng)
  opts
end

def randomizers(readiness, rnd)
  opts = {}
  if readiness >= 0.7
    opts["boosters"] = rnd.rand(readiness - 0.2..readiness)
    opts["blockers"] = rnd.rand((1-readiness)..(1-readiness) + 0.2)
  elsif readiness <= 0.2
    opts["boosters"] = rnd.rand(readiness..readiness + 0.2)
    opts["blockers"] = rnd.rand((1-readiness) - 0.2..(1-readiness))
  else
    opts["boosters"] = rnd.rand(readiness - 0.2..readiness + 0.2)
    opts["blockers"] = rnd.rand((1-readiness) - 0.2..(1-readiness) + 0.2)
  end
  opts["roadblocks"] = 100 - (((readiness*10) * 10).to_i + 5)
  opts
end

def cast_id(rng)
  id = rng.rand(1..100)
  while @cast_ids.include? id do
    id = rng.rand(1..100)
  end
  @cast_ids.push(id)
  id
end

def read_json_file
  file = File.read("app_demo_data.json")
  JSON.parse(file)
end

def write_json_file(new_apps)
  File.open("apps_with_cast.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

app_cast