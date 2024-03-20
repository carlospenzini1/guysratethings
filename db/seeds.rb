require 'bcrypt'
require 'date'

GUser.create(fname: "Carlos", lname: "Penzini", username: "carlos", password: BCrypt::Password.create("carlos22guys"), email:"cpenzini22@palmertrinity.org", created_at: DateTime.now, modified_at: DateTime.now, admin: true)
GUser.create(fname: "Joseph", lname: "Rivera", username: "jrivera", password: BCrypt::Password.create("1234APcs"), email:"jrivera@palmertrinity.org", created_at: DateTime.now, modified_at: DateTime.now, admin: true)
GUser.create(fname: "Nicholas", lname: "Hernandez", username: "nick", password: BCrypt::Password.create("nick22guys"), email:"nhernandez22@palmertrinity.org", created_at: DateTime.now, modified_at: DateTime.now, admin: true)
GUser.create(fname: "Nikolas", lname: "Gianulis", username: "niko", password: BCrypt::Password.create("niko22guys"), email:"ngianulis22@palmertrinity.org", created_at: DateTime.now, modified_at: DateTime.now, admin: true)
