require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

supplier = Supplier.create(name: "NIW", email:"test@niw.com", password:"test123")
offtaker = Offtaker.create(name: "Offtaker", email:"test@offtakers.com", password:"test123")

filepath_producers = Rails.root.join('./db/data/producer_data.csv')
filepath_offtakers = Rails.root.join('./db/data/offtaker_data.csv')

CSV.foreach((filepath_producers), headers: true, col_sep: ";") do |row|
  name = row[1]
  lon = row[4]
  lat = row[5]
  postal_code = row[7]
  house_nr = row[8]
  supply_type = row[9]
  min_hydrogen_vol = row[10].to_f
  max_hydrogen_vol = row[11].to_f
  min_oxygen_vol = row[12].to_f
  max_oxygen_vol = row[13].to_f
  pickup_available = (row[14] == 'TRUE') #if row is 'TRUE' return true as BOOL
  pressure_type_hydrogen = row[15].to_f
  pressure_type_oxygen = row[16].to_f
  verified = (row[17] == 'TRUE') #if row is 'TRUE' return true as BOOL
  available = (row[18] == 'TRUE') #if row is 'TRUE' return true as BOOL
  transport_costs = row[19].to_f
  compression_costs = row[20].to_f
  has_drftc = (row[21] == 'TRUE') #if row is 'TRUE' return true as BOOL
  hydrogen_purity = row[22]
  oxygen_purity = row[23]

  supplier_location = SupplierLocation.new(
    name: name,
    longitude: lon,
    latitude: lat,
    postal_code: postal_code,
    house_nr: house_nr,
    supply_type: supply_type,
    min_hydrogen_vol: min_hydrogen_vol,
    max_hydrogen_vol: max_hydrogen_vol,
    min_oxygen_vol: min_oxygen_vol,
    max_oxygen_vol: max_oxygen_vol,
    pickup_available: pickup_available,
    pressure_type_hydrogen: pressure_type_hydrogen,
    pressure_type_oxygen: pressure_type_oxygen,
    verified: verified,
    available: available,
    transport_costs: transport_costs,
    compression_costs: compression_costs,
    has_drftc: has_drftc,
    hydrogen_purity: hydrogen_purity,
    oxygen_purity: oxygen_purity,
  )
  supplier_location.supplier = supplier
  supplier_location.save!
  p supplier_location
end

CSV.foreach((filepath_offtakers), headers: true, col_sep: ";") do |row|
    name = row[1]
    lon = row[3]
    lat = row[4]
    postal_code = row[5]
    house_nr = row[6]
    own_transport = (row[7] == 'True') #if row is 'TRUE' return true as BOOL
    req_hydrogen_vol = row[8].to_f
    req_oxygen_vol = row[9].to_f
    req_pressure_hydrogen = row[10].to_f 
    req_pressure_oxygen = row[11].to_f
    required_purity_hydrogen = row[12]
    required_purity_oxygen = row[13]

  
    offtaker_location = OfftakerLocation.new(
      name: name,
      longitude: lon,
      latitude: lat,
      postal_code: postal_code,
      house_nr: house_nr,
      own_transport: own_transport,
      req_hydrogen_vol: req_hydrogen_vol,
      req_oxygen_vol: req_oxygen_vol,
      req_pressure_hydrogen: req_pressure_hydrogen,
      req_pressure_oxygen: req_pressure_oxygen,
      required_purity_hydrogen: required_purity_hydrogen,
      required_purity_oxygen: required_purity_oxygen
    )
    offtaker_location.offtaker = offtaker
    offtaker_location.save!
    p offtaker_location
    p ''
  end