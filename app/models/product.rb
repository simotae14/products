class Product < ActiveRecord::Base
	def self.to_csv#(options = {})
  		CSV.generate do |csv|
    		csv << column_names
    		all.each do |product|
      			csv << product.attributes.values_at(*column_names)
    		end
  		end
	end
	def self.import(file)  
  		CSV.foreach(file.path, headers: true) do |row|  
    		Product.create! row.to_hash  
  		end  
	end

  def self.import_two(file)  
    spreadsheet = open_spreadsheet(file)  
    header = spreadsheet.row(1)  
    (2..spreadsheet.last_row).each do |i|  
      row = Hash[[header, spreadsheet.row(i)].transpose]  
      product = Product.new(row.to_hash)  
      product.attributes = row.to_hash.slice(*accessible_attributes)  
      product.save!  
    end  
  end

  def self.open_spreadsheet(file)  
    case File.extname(file.original_filename)  
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)  
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)  
      else raise "Unknown file type: #{file.original_filename}"  
    end  
  end 
end
