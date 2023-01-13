# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# suplier = Supplier.create(name: 'Test', email: 'test@niw.com', password: "test123")


# CSV.foreach(filepath) do |row|
#   name = row[0]
#   supplier_location = SuppierLocation.new(
#     name: name
#   )
#   supplier_location.supplier = suplier
#   supplier_location.save
# end

supplier = Supplier.new(name: "Lars")

p supplier