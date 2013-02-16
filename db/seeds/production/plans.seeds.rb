Plan.create! name: "Free", price: 0, customers: 2, logs: 100, projects: 2, users:2
Plan.create! name: "Bronze", price: 19, customers: nil, logs: nil, projects: 50, users:10
Plan.create! name: "Silver", price: 49, customers: nil, logs: nil, projects: 200, users:30
Plan.create! name: "Gold", price: 99, customers: nil, logs: nil, projects: 400, users:100
Plan.create! name: "Platinum", price: 199, customers: nil, logs: nil, projects: nil, users:nil

puts "Plans added"

