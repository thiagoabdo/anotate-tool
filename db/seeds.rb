# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


bob = User.create(:email => 'test@c3sl.ufpr.br', :password => '123mudar')

ds = Dataset.create(:name => 'MeuProjeto', :description => 'Esse é o projeto do Bob')
rs = Role.create([{ :user_id => bob.id, :dataset_id => ds.id, :role => '0' }])
