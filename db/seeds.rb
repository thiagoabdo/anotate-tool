# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create(:email => 'bob@c3sl.ufpr.br', :password => '123mudar')
bob = User.where(:email => 'bob@c3sl.ufpr.br').first
p bob

ds = Dataset.where(:description => 'Esse é o projeto do Bob', :name => 'Projeto do Bob').first_or_initialize
ds.save!

rs = Role.where({:user_id => bob.id, :dataset_id => ds.id, :role => 0}).first_or_initialize
rs.save!

User.create(:email => 'alice@c3sl.ufpr.br', :password => '123mudar')
alice = User.where(:email => 'alice@c3sl.ufpr.br').first
p alice

rs2 = Role.where({:user_id => alice.id, :dataset_id => ds.id, :role => 1}).first_or_initialize
rs2.save!

Observation.destroy_by(:dataset_id => ds.id)
easy = Observation.create(:dataset_id , :name => "Easy")
aaa = AttrValue.create(:observation_id => easy.id, :value => "AAA")
bbb = AttrValue.create(:observation_id => easy.id, :value => "BBB")
random = Observation.create(:dataset_id => ds.id, :name => "Random")
r1 = AttrValue.create(:observation_id => random.id, :value => "R1")
r2 = AttrValue.create(:observation_id => random.id, :value => "R2")
rand_attr = [r1.id, r2.id]

Entry.destroy_by(:dataset_id => ds.id)
100.times do |index|
    e = Entry.create(:dataset_id => ds.id, :text => "AAA " + Faker::Lorem.sentence(word_count:3, supplemental:false, random_words_to_add:2).chop)
    if index < 50
        Notation.create(:user_id => bob.id, :attr_value_id => aaa.id, :entry_id => e.id, :observation_id => easy.id)
        Notation.create(:user_id => bob.id, :attr_value_id => rand_attr.sample, :entry_id => e.id, :observation_id => random.id)
    end
end

100.times do |index|
    e = Entry.create(:dataset_id => ds.id, :text => "BBB " + Faker::Lorem.sentence(word_count:3, supplemental:false, random_words_to_add:2).chop)
    if index < 50
        Notation.create(:user_id => bob.id, :attr_value_id => bbb.id, :entry_id => e.id, :observation_id => easy.id)
        Notation.create(:user_id => bob.id, :attr_value_id => rand_attr.sample, :entry_id => e.id, :observation_id => random.id)
    end
end


ds = Dataset.where(:description => 'Esse é o projeto do Alice', :name => 'Projeto do Alice').first_or_initialize
ds.save!
rs = Role.where({:user_id => alice.id, :dataset_id => ds.id, :role => 0}).first_or_initialize
rs.save!
Observation.destroy_by(:dataset_id => ds.id)
easy = Observation.create(: , :name => "EZ2")
aaa = AttrValue.create(:observation_id => easy.id, :value => "AliceA")
bbb = AttrValue.create(:observation_id => easy.id, :value => "AliceB")
Entry.destroy_by(:dataset_id => ds.id)
20.times do |index|
    e = Entry.create(:dataset_id => ds.id, :text => "Alice " + Faker::Lorem.sentence(word_count:3, supplemental:false, random_words_to_add:2).chop)
end
