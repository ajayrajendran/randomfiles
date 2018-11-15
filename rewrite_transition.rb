require 'json'

def read_json_file(filename = "transition_new.json")
  file = File.read(filename)
  JSON.parse(file)
end


def write_json_file(new_apps)
  File.open("transition_3.json","w") do |f|
    f.write(JSON.pretty_generate(new_apps))
  end
end

def rewrite
  clouds = ["Amazon Web Services", "Azure", "Google Cloud Platform"]
  types = ["replatform", "refactor", "retain", "rehost", "retire", "repurchase"]
  data = read_json_file
  new_hash = {}
  data.each do |key, value|
    clouds.each do |cloud|
      if key.include? cloud
        index = key.index(cloud) + cloud.length + 1
        key = key[index..-1]
        types.each do |type|
          if key.include? type
            index = key.index(type) + type.length + 1
            key = key[index..-1]
            if new_hash[type] == nil
              new_hash[type] = {cloud => {key => value}}
            else
              if(new_hash[type][cloud] == nil)
                new_hash[type] = new_hash[type].merge!({cloud => {key => value}})
              else
                new_hash[type][cloud] = new_hash[type][cloud].merge!({key => value})
              end
            end
            break
          end
        end
        break
      end
    end
  end
  
  write_json_file(new_hash)
end

rewrite
