require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Customer

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = options["id"].to_i if options["id"]
        @name = options["name"]
        @funds = options["funds"].to_i
    end


    # boolean checks
    def can_afford_ticket?(film)
        return @funds >= film.price
    end


    # property manipulators
    def pay(amount)
        @funds -= amount
    end
    

    # helpers
    def self.map_items(data)
        data.map {|customer| self.new(customer)}
    end

    def ticket_count
        return tickets.count
    end


    # CREATE
    def save
        sql = "INSERT INTO customers
        (name, funds)
        VALUES ($1, $2)
        RETURNING id"
        values = [@name, @funds]
        
        result = SqlRunner.run(sql, values).first
        @id = result["id"].to_i
    end
    

    # READ
    def self.all
        sql = "SELECT * FROM customers"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def self.find(id)
        sql = "SELECT * FROM customers
        WHERE id = $1"
        values = [id]

        result = SqlRunner.run(sql, values).first
        result ? self.new(result) : nil 
    end


    # UPDATE
    def update
        sql = "UPDATE customers
        SET (name, funds)
        = ($1, $2)
        WHERE id = $3"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end


    # DELETE
    def self.delete_all
        sql = "DELETE FROM customers"
        SqlRunner.run(sql)
    end

    def delete
        sql = "DELETE FROM customers
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end


    # find related data
    def films
        sql = "SELECT films.* FROM 
        films INNER JOIN screenings
        ON films.id = screenings.film_id
        INNER JOIN tickets
        ON screenings.id = tickets.screening_id
        WHERE tickets.customer_id = $1"
        values = [@id]

        result = SqlRunner.run(sql, values)
        return Film.map_items(result)
    end

    def tickets
        sql = "SELECT * FROM tickets
        WHERE customer_id = $1"
        values = [@id]
        
        result = SqlRunner.run(sql, values)
        return Film.map_items(result)
    end


    # behaviours
    def buy_ticket(screening)
        return "Could not buy ticket—insufficient funds" if !can_afford_ticket?(screening.film)
        return "Could not buy ticket—screening sold out" if !screening.has_seats_left?
            
        pay(screening.film.price)
        update

        ticket = Ticket.new({"customer_id" => @id, "screening_id" => screening.id})
        ticket.save

        return "#{@name} bought ticket for #{screening.film.title} at #{screening.time}"
    end

end
