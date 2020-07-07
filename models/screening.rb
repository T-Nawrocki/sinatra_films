require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Screening

    attr_reader :id
    attr_accessor :time, :seats, :film_id

    def initialize(options)
        @id = options["id"].to_i if options["id"]
        @time = options["time"]
        @seats = options["seats"].to_i
        @film_id = options["film_id"].to_i
    end
    

    # boolean checks
    def has_seats_left?
        return @seats > tickets_count
    end
    
    
    # helpers
    def self.map_items(data)
        data.map {|screening| self.new(screening)}
    end

    def tickets_count
        return tickets.count
    end


    # CREATE
    def save
        sql = "INSERT INTO screenings
        (time, seats, film_id)
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@time, @seats, @film_id]

        result = SqlRunner.run(sql, values).first
        @id = result["id"].to_i
    end


    # READ
    def self.all
        sql = "SELECT * FROM screenings"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def self.find(id)
        sql = "SELECT * FROM screenings
        WHERE id = $1"
        values = [id]

        result = SqlRunner.run(sql, values).first
        result ? self.new(result) : nil
    end


    # UPDATE
    def update
        sql = "UPDATE screenings
        SET (time, seats, film_id)
        = ($1, $2, $3)
        WHERE id = $4"
        values = [@time, @seats, @film_id, @id]
        SqlRunner.run(sql, values)
    end


    # DELETE
    def self.delete_all
        sql = "DELETE FROM screenings"
        SqlRunner.run(sql)
    end

    def delete 
        sql = "DELETE FROM screenings
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    
    # find related data
    def film
        sql = "SELECT * FROM films
        WHERE films.id = $1"
        values = [@film_id]

        result = SqlRunner.run(sql, values).first
        return Film.new(result)
    end

    def tickets
        sql = "SELECT * FROM tickets
        WHERE screening_id = $1"
        values = [@id]

        result = SqlRunner.run(sql, values)
        return Ticket.map_items(result)
    end

    def self.most_popular
        return self.all.max_by {|screening| screening.tickets_count}
    end

end
