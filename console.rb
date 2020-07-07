require("pry")

require_relative("models/customer")
require_relative("models/film")
require_relative("models/ticket")
require_relative("models/screening")

Ticket.delete_all
Screening.delete_all
Customer.delete_all
Film.delete_all


customer_1 = Customer.new({
    "name" => "Rincewind",
    "funds" => "5"
})
customer_2 = Customer.new({
    "name" => "Mustrum",
    "funds" => "100"
})
customer_1.save
customer_2.save


film_1 = Film.new({
    "title" => "The Hogfather",
    "price" => "5"
})
film_2 = Film.new({
    "title" => "Feet of Clay",
    "price" => "10"
})
film_1.save
film_2.save

screening_1 = Screening.new({
    "time" => "16.30",
    "seats" => 4,
    "film_id" => film_1.id
})
screening_2 = Screening.new({
    "time" => "19.30",
    "seats" => 10,
    "film_id" => film_1.id
})
screening_1.save
screening_2.save

ticket_1 = Ticket.new({
    "customer_id" => customer_1.id,
    "screening_id" => screening_1.id
})
ticket_2 = Ticket.new({
    "customer_id" => customer_2.id,
    "screening_id" => screening_1.id
})
ticket_1.save
ticket_2.save


# customer_1.funds = 10
# customer_1.update

# film_1.price = 6
# film_1.update

# ticket_1.customer_id = customer_2.id
# ticket_1.update

# ticket_1.delete
# customer_1.delete
# film_2.delete


# screening_1.time = "15.30"
# screening_1.update

# screening_1.delete


binding.pry
nil