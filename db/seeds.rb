# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#!/bin/env ruby
Firm.delete_all
Log.delete_all
Plan.delete_all
Customer.delete_all
User.delete_all
Employee.delete_all
Log.delete_all
class Array
  def / len
  a = []
  each_with_index do |x,i|
  a << [] if i % len == 0
  a.last << x
  end
  a
  end
end
Plan.create! name: "Free", price: 0, customers: 2, logs: 100, projects: 2, users:2, paymill_id: '12'
Plan.create! name: "Bronze", price: 19, customers: nil, logs: nil, projects: 50, users:10, paymill_id: '12'
Plan.create! name: "Silver", price: 49, customers: nil, logs: nil, projects: 200, users:30, paymill_id: '12'
gold_plan = Plan.create! name: "Gold", price: 99, customers: nil, logs: nil, projects: 400, users:100, paymill_id: '12'
Plan.create! name: "Platinum", price: 199, customers: nil, logs: nil, projects: nil, users:nil, paymill_id: '12'

puts "Plans added"
puts "setting up first firm"
firm1 = Firm.create! name: "Lizz", 
                      subdomain: "lizz", 
                      plan_id: gold_plan.id, currency: "USD",
                      language: "en-US",
                      time_zone: "Berlin",
                      tax: 25.0,
                      reminder_fee: 50.0,
                      bank_account: '123',
                      vat_number: '123',
                      time_format: 1,
                      date_format: 1,
                      clock_format: 1

puts 'New firm created: ' << firm1.name
firm2 = Firm.create! :name => "video", :subdomain => "video", plan: gold_plan
puts 'New firm created: ' << firm2.name
puts 'SETTING UP EXAMPLE USERS'
user1 = User.new :name => 'Andreas Lyngstad', hourly_rate: 1000.0, :email => 'andreas@lizz.no', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user1.firm = firm1
user1.save
puts 'New user created: ' << user1.name
user2 = User.new :name => 'Agnes Whittington', :email => 'axel@lizz.no', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user2.firm = firm1
user2.save
puts 'New user created: ' << user2.name
user3 = User.new :name => 'Christoffer Banes', :email => 'tiril@lizz.no', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user3.firm = firm1
user3.save
puts 'New user created: ' << user3.name
user4 = User.new :name => 'Dorian Gaughan', :email => 'astrid@lizz.no', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user4.firm = firm1
user4.save
puts 'New user created: ' << user4.name
user5 = User.new :name => 'Jeanett Meaux', :email => 'astrid@lizz.no', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user5.firm = firm1
user5.save
puts 'New user created: ' << user4.name
n = 1
100.times do |n|
  n + 1
user5 = User.new :name => 'Andreas Lyngstad#{n}', :email => 'andreaslyngstad#{n}@gmail.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user5.firm = firm1
user5.save
end
puts 'New user created: ' << user5.name

puts "Setting up customers"
customers1 = Customer.new :name => "Harald Bråhten", :phone => "96979892", :email => "harald@braten.no"
customers1.firm = firm1
customers1.save
puts 'New customer created: ' << customers1.name
customers2 = Customer.new :name => "Jens Trand", :phone => "96979892", :email => "jens@trand.no"
customers2.firm = firm1
customers2.save
puts 'New customer created: ' << customers2.name
customers3 = Customer.new :name => "Olav Hansen", :phone => "96979892", :email => "olav@hansen.no"
customers3.firm = firm2
customers3.save
puts 'New customer created: ' << customers3.name
customers4 = Customer.new :name => "Trine Vind", :phone => "96979892", :email => "Trine@vind.no"
customers4.firm = firm2
customers4.save
puts 'New customer created: ' << customers4.name

open("db/seeds/customers") do |customers|
  customers.read.each_line do |customer|
    customer_made = Customer.new(:name => customer)
    customer_made.firm = firm1
    customer_made.email = "andreaslyngstad@gmail.com"
    customer_made.save
    
    puts "Made customer : "<< customer_made.name
end
end
puts "Setting up Employees"

employees1 = Employee.new :name => "Per Bråhten", :customer_id => "1", :phone => "96979892", :email => "per@braten.no"
employees1.firm = firm1
employees1.save
puts 'New employees created: ' << employees1.name
employees2 = Employee.new :name => "Knut Bråhten", :customer_id => "1", :phone => "96979892", :email => "knut@braten.no"
employees2.firm = firm1
employees2.save
puts 'New employees created: ' << employees2.name
employees3 = Employee.new :name => "Per Trand", :customer_id => "2", :phone => "96979892", :email => "per@trand.no"
employees3.firm = firm1
employees3.save
puts 'New employees created: ' << employees3.name
employees4 = Employee.new :name => "Knut Trand", :customer_id => "2", :phone => "96979892", :email => "per@trand.no"
employees4.firm = firm1
employees4.save
puts 'New employees created: ' << employees4.name
employees5 = Employee.new :name => "Felix Vind", :customer_id => "2", :phone => "96979892", :email => "per@vind.no"
employees5.firm = firm1
employees5.save
puts 'New employees created: ' << employees5.name
employees6 = Employee.new :name => "Per Vind", :customer_id => "2", :phone => "96979892", :email => "per@vind.no"
employees6.firm = firm1
employees6.save
puts 'New employees created: ' << employees6.name
employees7 = Employee.new :name => "Alf Hansen", :customer_id => "3", :phone => "96979892", :email => "per@hansen.no"
employees7.firm = firm2
employees7.save
puts 'New employees created: ' << employees7.name
employees8 = Employee.new :name => "Einar Hansen", :customer_id => "3", :phone => "96979892", :email => "per@hansen.no"
employees8.firm = firm2
employees8.save
puts 'New employees created: ' << employees8.name
puts "Setting up projects"
projects1 = Project.new :name => "lizz", :active => true
Membership.create!(:user_id => 1, :project_id => projects1.id)
projects1.firm = firm1
projects1.save
puts 'New project created: ' << projects1.name
projects2 = Project.new :name => "fix car", :customer_id => "1", :active => true
Membership.create!(:user_id => 1, :project_id => projects2.id)
projects2.firm = firm1
projects2.save
puts 'New project created: ' << projects2.name
projects3 = Project.new :name => "fix moped", :customer_id => "2", :active => true
Membership.create!(:user_id => 1, :project_id => projects3.id)
projects3.firm = firm1
projects3.save
puts 'New project created: ' << projects3.name
projects4 = Project.new :name => "clean house", :active => true
Membership.create!(:user_id => 1, :project_id => projects4.id)
projects4.firm = firm1
projects4.save
puts 'New project created: ' << projects4.name

projects5 = Project.new :name => "fix barn", :active => true
Membership.create!(:user_id => 5, :project_id => projects5.id)
projects5.firm = firm2
projects5.save
puts 'New project created: ' << projects5.name
projects6 = Project.new :name => "Paint fence", :active => true, :customer_id => "4"
Membership.create!(:user_id => 5, :project_id => projects6.id)
projects6.firm = firm2
projects6.save
puts 'New project created: ' << projects6.name
open("db/seeds/projects") do |projects|
  projects.read.each_line do |project|
    
    n = project.chomp.split("|")
    c = n[0]
    p = n[1]
    
    projects_made = Project.new(:name => c, :description => p , :active => true)
    projects_made.firm = firm1
    projects_made.save
    puts "Made Project : " << projects_made.name
    Membership.create!(:user_id => 1, :project_id => projects_made.id)
  end
end

puts "Setting up todos"
todo1 = Todo.new :name => "Sell music", :project_id => "1", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo1.name
todo2 = Todo.new :name => "Fill water", :project_id => "4", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo2.name
todo3 = Todo.new :name => "Record music", :project_id => "1", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo3.name
todo4 = Todo.new :name => "Moan loan", :project_id => "4", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo4.name
todo5 = Todo.new :name => "Camshaft", :project_id => "2", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo5.name
todo6 = Todo.new :name => "Cyllinder", :project_id => "2", :due => Time.now + 3000000, :completed => false
puts 'New todo created: ' << todo6.name
todos = [todo1,todo2,todo3,todo4,todo5, todo6]
todos.each do |todo|
  todo.firm = firm1
  todo.save
end

puts "Setting up logs"
time4daysago = Time.zone.today - 4.days
time6daysago = Time.zone.today - 6.days
timeyesterday = Time.zone.today - 1.days
today = Time.zone.today - 1.days + 1.days
# firm1.logs.new( :user_id => user1.id, :event => "Sell DDE",        :project_id => projects1.id, :todo_id => "1", :tracking => false, :log_date => Time.zone.today - 1.days + 1.days, :begin_time => Time.now, :end_time => Time.now + 1.hours).save
# firm1.logs.new( :user_id => user1.id, :event => "Sell Dumdumboys", :project_id => projects1.id, :todo_id => "1", :tracking => false, :log_date => today, :begin_time => Time.now - 1.hours, :end_time => Time.now).save
# firm1.logs.new( :user_id => user1.id, :event => "Record nicolai",  :project_id => projects1.id, :todo_id => "2", :tracking => false, :log_date => today, :begin_time => Time.now - 3.hours, :end_time => Time.now).save
# firm1.logs.new( :user_id => user1.id, :event => "Record slalom",   :project_id => projects1.id, :todo_id => "2", :tracking => false, :log_date => today, :begin_time => Time.now - 5.hours, :end_time => Time.now).save
# firm1.logs.new( :user_id => user1.id, :event => "Making poster",   :project_id => projects1.id, :tracking => false, :log_date => today, :begin_time => Time.now + 1.hours, :end_time => Time.now + 3.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Sell nicolai",    :project_id => projects1.id, :tracking => false, :log_date => time4daysago, :begin_time => time4daysago, :end_time => time4daysago + 5.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Sell nicolai",    :project_id => projects1.id, :tracking => false, :log_date => time4daysago, :begin_time => time4daysago + 5.hours, :end_time => time4daysago + 7.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Unscrew",         :project_id => projects2.id, :todo_id => "5", :tracking => false, :log_date => time4daysago, :begin_time => time4daysago, :end_time => time4daysago + 1.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Take wheel off",  :project_id => projects2.id, :todo_id => "5", :tracking => false, :log_date => time6daysago, :begin_time => time6daysago + 3.hours, :end_time => time6daysago + 5.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Remove spring",   :project_id => projects2.id, :todo_id => "6", :tracking => false, :log_date => time6daysago, :begin_time => time6daysago + 5.hours, :end_time => time6daysago + 6.hours).save
# firm1.logs.new( :user_id => user2.id, :event => "Take off hood",   :project_id => projects2.id, :todo_id => "6", :tracking => false, :log_date => time6daysago, :begin_time => timeyesterday, :end_time => timeyesterday + 6.hours).save
 


puts "Setting up milestones"
milestone1 = Milestone.new :goal => "Make music", :project_id => "1", :due => Time.now + 3000000, :completed => false
milestone1.firm = firm1
milestone1.save
puts 'New milestone created: ' << milestone1.goal
milestone2 = Milestone.new :goal => "Record music", :project_id => "1", :due => Time.now + 3100000, :completed => false
milestone2.firm = firm1
milestone2.save
puts 'New milestone created: ' << milestone2.goal
milestone3 = Milestone.new :goal => "Press music", :project_id => "1", :due => Time.now + 3200000, :completed => false
milestone3.firm = firm1
milestone3.save
puts 'New milestone created: ' << milestone3.goal
milestone4 = Milestone.new :goal => "Sell music", :project_id => "1", :due => Time.now + 3400000, :completed => false
milestone4.firm = firm1
milestone4.save
puts 'New milestone created: ' << milestone4.goal


