# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create( name: 'Petras', surname: 'Petraitis', money: 750 )
Account.create( name: 'Jonas', surname: 'Jonaitis', money: 1500 )
Account.create( name: 'Ona', surname: 'Onaite', money: 3300 )

Payment.create( from: 1, to: 2, amount: 300 )
Payment.create( from: 2, to: 3, amount: 400 )
Payment.create( from: 3, to: 1, amount: 600 )

Branch.create( address: 'Vilnius, Konstitucijos pr. 20' )
Branch.create( address: 'Kaunas, Vilniaus g. 30' )
