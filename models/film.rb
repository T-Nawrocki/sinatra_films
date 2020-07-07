require_relative("../db/sql_runner")
require_relative("customer")
require_relative("screening")

class Film

    attr_reader :id
    attr_accessor :title, :price

    def initialize(options)
       @id = options["id"].to_i if options["id"]
       @title = options["title"]
       @price = options["price"].to_i 
    end


    # helpers
    def self.map_items(data)
        data.map {|film| self.new(film)}
    end

    def customer_count
        return customers.count
    end


    # CREATE
    def save
        sql = "INSERT INTO films
        (title, price)
        VALUES ($1, $2)
        RETURNING id"
        values = [@title, @price]

        result = SqlRunner.run(sql, values).first
        @id = result["id"].to_i
    end


    # READ
    def self.all
        sql = "SELECT * FROM films"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def self.find(id)
        sql = "SELECT * FROM films
        WHERE id = $1"
        values = [id]

        result = SqlRunner.run(sql, values).first
        result ? self.new(result) : nil
    end


    # UPDATE
    def update
        sql = "UPDATE films
        SET (title, price)
        = ($1, $2)
        WHERE id = $3"
        values = [@title, @price, @id]
        SqlRunner.run(sql, values)
    end


    # DELETE
    def self.delete_all
        sql = "DELETE FROM films"
        SqlRunner.run(sql)
    end

    def delete 
        sql = "DELETE FROM films
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end


    # find related data
    def customers
        sql = "SELECT customers.* FROM
        customers INNER JOIN tickets
        ON customers.id = tickets.customer_id
        INNER JOIN screenings
        ON tickets.screening_id = screenings.id
        WHERE screenings.film_id = $1"
        values = [@id]

        result = SqlRunner.run(sql, values)
        return Customer.map_items(result)
    end

    def screenings
        sql = "SELECT * FROM screenings
        WHERE film_id = $1"
        values = [@id]

        result = SqlRunner.run(sql, values)
        return Screening.map_items(result)
    end

    def most_popular_screening
       return screenings.max_by {|screening| screening.tickets_count} 
    end

end
