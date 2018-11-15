
=begin DO NOT DELETE
require 'spreadsheet'
require 'json'

module GenerateExcel
  
  def generate_excel(args)
    if(args[:minimal] == "true")
      @number_of_items = 10
      @number_of_items = args[:number].to_i if args[:number] != nil
      args[:short_list] = args[:number] != nil
      create_book(args, "data/minimal_app.json","data/minimal_db.json")
    else
      create_book
    end
  end
  
  def create_book(args, app_json = "data/app_demo_data.json", db_json = "data/database_demo_data.json", server_json = "data/server_demo_data.json", vc_json = "data/vc_demo_data.json")
    @book = Spreadsheet::Workbook.new
    
    new_data = {}
    if args[:short_list]
      new_data = create(@number_of_items)
    end
    populate_sheet("applications", app_json, new_data[:apps])
    populate_server("servers", server_json, new_data[:servers])
    populate_sheet("databases", db_json, new_data[:dbs])
    populate_sheet("virtualization_clusters", vc_json)
    
    if(app_json == "data/minimal_app.json")
      filename = "demo_data_minimal"
      filename = args[:filename].to_s if args[:filename] != nil
      @book.write "data/#{filename}.xls"
    else
      @book.write "data/demo_data_new.xls"
    end
  end
  
  def format_sheet(sheet)
    format_first_row(set_width(set_height(sheet)))
  end
  
  def set_height(sheet)
    sheet.each do |row|
      row.height = 20
      size_format = Spreadsheet::Format.new :size => 12
      row.default_format = size_format
    end
    sheet
  end
  
  def set_width(sheet)
    column_sizes = {}
    sheet.each do |row|
      col_keys = column_sizes.keys
      row.each_with_index do |cell, col_idx|
        if col_keys.include? col_idx
          if column_sizes[col_idx] <= cell.to_s.length
            column_sizes[col_idx] = cell.to_s.length
          end
        else
          column_sizes[col_idx] = cell.to_s.length
        end
      end
    end
    
    column_sizes.keys.each do |column_idx|
      sheet.column(column_idx).width = column_sizes[column_idx] + 10
    end
    sheet
  end
  
  def format_first_row(sheet)
    sheet.row(0).each_with_index do |cell, cell_idx|
      sheet.row(0).set_format(cell_idx, RowFormat.new(:xls_color_19, :bold, :medium))
    end
  end
  
  def read_json_content(filename)
    file = File.read(filename)
    JSON.parse(file)
  end
  
  def populate_sheet(sheet_name, filename, data = nil)
    data = read_json_content(filename) if data == nil
    first_row = data[data.keys.sample].keys
    sheet = @book.create_worksheet :name => sheet_name
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
    format_sheet(sheet)
  end
  
  def populate_server(sheet_name, filename, data = nil)
    data = read_json_content(filename) if data == nil
    first_row = data[data.keys.sample][0].keys
    sheet = @book.create_worksheet :name => sheet_name
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
    format_sheet(sheet)
  end
  
  def create(number_of_items)
    @key_list = []
    list_of_objects = {}
    list_of_objects[:apps] = create_app
    list_of_objects[:servers] = create_data("data/server_demo_data.json")
    list_of_objects[:dbs] = create_data("data/minimal_db.json")
    list_of_objects
  end
  
  def create_app
    data = read_json_content("data/minimal_app.json")
    new_list = {}
    data.first(@number_of_items).to_h.each do |key, app|
      @key_list.push(key)
      new_list[key] = app
    end
    puts "there are #{new_list.keys.count} apps in the new list"
    new_list
  end
  
  def create_data(filename)
    data = read_json_content(filename)
    new_list = {}
    data.each do |key, value|
      if @key_list.include? key
        new_list[key] = value
      end
    end
    new_list
  end
end

class RowFormat < Spreadsheet::Format
  def initialize(color, thickness, boldness)
    super :pattern => 1, :pattern_fg_color => color, :weight => thickness, :bottom => boldness, :size => 12
  end
end
=end THIS IS THE ORIGINAL DO NOT DELETE