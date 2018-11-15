require 'json'
require 'faker'

def read_file(filename = "updated.json")
  file = File.read(filename)
  JSON.parse(file)
end

def get_dates
  data = read_file
  dates = []
  data.each do |url, app|
    date = app["transition wave"].split
    date = date[-1]
    dates.push(date) unless dates.include?(date)
  end
  dates
end

def get_names
  dates = get_dates
  data = read_file
  names = {}
  dates.each do |date|
    data.each do |url, app|
      if app["transition wave"].include?(date)
        if(names.key?(date))
          names[date] = names[date].push(app["tech lead"])
        else
          names[date] = [app["tech lead"]]
        end
      end
    end
  end
  names
end

def create
  dates = get_dates
  move_groups = {}
  names = get_names
  dates.each do |date|
    move_groups["Move Group - #{date}"] = {
      "Notes": "Tech Lead: #{names[date].sample}, Project Manager: #{Faker::Name.unique.name}",
      "Communications": "Move Group planning is now complete. We anticipate to start at 5:00pm on #{date}. Please dial in to the bridge 5 mins prior. Number: #{Faker::PhoneNumber.phone_number}"
    }
  end
  to_json_file(move_groups)
end

def to_json_file(move_groups)
  File.open("move_groups.json","w") do |f|
    f.write(JSON.pretty_generate(move_groups))
  end
end

create