require 'spreadsheet'
require 'json'

def create_book
  book = Spreadsheet::Workbook.new
  application_sheet = book.create_worksheet :name => "applications"
  server_sheet = book.create_worksheet :name => "servers"
  db_sheet = book.create_worksheet :name => "databases"
  vc_sheet = book.create_worksheet :name => "virtualization_clusters"
  
  application_sheet = populate_sheet(application_sheet, "app_demo_data.json")
  server_sheet = populate_server(server_sheet, "server_demo_data.json")
  db_sheet = populate_sheet(db_sheet, "db_demo_data.json")
  vc_sheet = populate_sheet(vc_sheet, "vc_demo_data.json")
  
  form = Spreadsheet::Format.new :weight => :bold
  application_sheet.row(0).default_format = form
  server_sheet.row(0).default_format = form
  db_sheet.row(0).default_format = form
  vc_sheet.row(0).default_format = form
  
  book.write "demo_data_new_2.xlsx"
end

def read_json_content(filename)
  file = File.read(filename)
  JSON.parse(file)
end

def populate_sheet(sheet, filename)
  data = read_json_content(filename)
  first_row = data[data.keys.sample].keys
  sheet.row(0).concat(first_row)
  row_count = 1
  data.each do |title, content|
    first_row = sheet.row(0)
    content.each do |key, value|
      cur_row = sheet.row(row_count)
      col = first_row.index(key)
      if value.is_a? Array
        value = value.join(", ")
      end
      value = "Yes" if value == true
      value = "No" if value == false
      cur_row.insert col, value
    end
    row_count += 1
  end
  sheet
end

def populate_server(sheet, filename)
  data = read_json_content(filename)
  first_row = data[data.keys.sample][0].keys
  sheet.row(0).concat(first_row)
  row_count = 1
  data.each do |title, content_array|
    first_row = sheet.row(0)
    content_array.each do |content|
      content.each do |key, value|
        cur_row = sheet.row(row_count)
        col = first_row.index(key)
        if value.is_a? Array
          value = value.join(", ")
        end
        cur_row.insert col, value
      end
      row_count += 1
    end
  end
  sheet
end

create_book
