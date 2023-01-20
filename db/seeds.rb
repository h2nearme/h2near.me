# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

supplier = Supplier.new(name: "NIW", email:"test@niw.com", password:"test123")

filepath = './data/producer_data.csv'
CSV.foreach(filepath) do |row|
  name = row[1]
  lon = row[4]
  lat = row[5]

  supplier_location = SuppierLocation.new(
    name: name
    longitude: lon
    latitude: lat
  )
  supplier_location.supplier = suplier
  supplier_location.save
end


end