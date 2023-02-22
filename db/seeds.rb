require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

supplier = Supplier.create(name: "NIW", email:"test@niw.com", password:"test123")
offtaker = Offtaker.create(name: "Offtaker", email:"test@offtakers.com", password:"test123")

filepath_producers = Rails.root.join('./db/data/producer_data.csv')
filepath_offtakers = Rails.root.join('./db/data/offtaker_data.csv')

types = [{
  name: 'Standard', # ~98% / 1nine
  minimum_hydrogen_volume: 100,
  maximum_hydrogen_volume: 100000000,
  pressure_type_hydrogen: 350,
  compression_costs: 1.1396,
  transport_costs: 0.182269
},
{
  name: 'ITMs', # ~99.8% / 2nines
  minimum_hydrogen_volume: 100,
  maximum_hydrogen_volume: 100000,
  pressure_type_hydrogen: 700,
  compression_costs: 1.1396,
  transport_costs: 0.182269
},
{
  name: 'Pure', # >=99.99% / 4nines
  minimum_hydrogen_volume: 100,
  maximum_hydrogen_volume: 10000000,
  pressure_type_hydrogen: 700,
  compression_costs: 1.1396,
  transport_costs: 0.182269
},
{
  name: 'High pure', # >=99.999% / 5nines
  minimum_hydrogen_volume: 200,
  maximum_hydrogen_volume: 100000,
  pressure_type_hydrogen: 350,
  compression_costs: 1.1396,
  transport_costs: 0.182269
},
{
  name: 'Ultrapure', # >=99.9999% / 6nines
  minimum_hydrogen_volume: 400,
  maximum_hydrogen_volume: 1000000,
  pressure_type_hydrogen: 700,
  compression_costs: 1.1396,
  transport_costs: 0.182269
}]

CSV.foreach((filepath_producers), headers: true, col_sep: ";") do |row|
  name = row[1]
  lat = row[4].to_f
  lon = row[5].to_f
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
  has_drtfc = (row[21] == 'TRUE') #if row is 'TRUE' return true as BOOL
  hydrogen_purity = row[22]
  oxygen_purity = row[23]

  supplier_location = SupplierLocation.new(
    name: name,
    longitude: lon,
    latitude: lat,
    postal_code: postal_code,
    house_nr: house_nr,
    pickup_available: pickup_available,
    verified: verified,
    available: available,
    has_drtfc: has_drtfc,
  )
  supplier_location.supplier = supplier
  supplier_location.save!
  p supplier_location

  types.first(rand(1..5)).each do |attributes|
    p attributes
    supply_type = SupplyType.new(attributes)
    supply_type.supplier_location = supplier_location
    supply_type.save!
  end
end

CSV.foreach((filepath_offtakers), headers: true, col_sep: ";") do |row|
    name = row[1]
    lat = row[3].to_f
    lon = row[4].to_f
    postal_code = row[5]
    house_nr = row[6]
    own_transport = (row[7] == 'True') #if row is 'TRUE' return true as BOOL
    req_hydrogen_vol = row[8].to_f
    req_oxygen_vol = row[9].to_f
    req_pressure_hydrogen = row[10].to_f 
    req_pressure_oxygen = row[11].to_f
    required_purity_hydrogen = row[12]
    interest_oxygen = row[14]
    investment_period_years = row[15]
    contract_period_years = row[16]

    offtaker_location = OfftakerLocation.new(
      name: name,
      longitude: lon,
      latitude: lat,
      postal_code: postal_code,
      house_nr: house_nr,
      own_transport: own_transport,
      required_hydrogen_volume: req_hydrogen_vol,
      required_oxygen_volume: req_oxygen_vol,
      required_hydrogen_pressure: req_pressure_hydrogen,
      required_hydrogen_purity: required_purity_hydrogen,
      interest_oxygen: interest_oxygen,
      investment_period_years: investment_period_years,
      contract_period_years: contract_period_years
    )
    offtaker_location.offtaker = offtaker
    offtaker_location.save!
    p offtaker_location
    p ''
  end