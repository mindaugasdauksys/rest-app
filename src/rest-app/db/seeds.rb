# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create( name: 'Petras', surname: 'Petraitis', amount: 750 )
Account.create( name: 'Jonas', surname: 'Jonaitis', amount: 1500 )
Account.create( name: 'Ona', surname: 'Onaite', money: Money.new(3300, 'USD') )

Payment.create( from: 1, to: 2, money: Money.new(300, 'EUR') )
Payment.create( from: 2, to: 3, money: Money.new(400, 'USD') )
Payment.create( from: 3, to: 1, money: Money.new(600, 'EUR') )

Branch.create( address: 'Vilnius, Konstitucijos pr. 20' )
Branch.create( address: 'Kaunas, Vilniaus g. 30' )
