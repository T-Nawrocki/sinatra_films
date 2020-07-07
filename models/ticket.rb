require_relative("../db/sql_runner")

class Ticket

    attr_reader :id
    attr_accessor :customer_id, :screening_id

    def initialize(options)
        @id = options["id"].to_i if options["id"]
        @customer_id = options["customer_id"].to_i
        @screening_id = options["screening_id"].to_i
    end


    # helpers
    def self.map_items(data)
        data.map {|ticket| self.new(ticket)}
    end


    # CREATE
    def save
        sql = "INSERT INTO tickets
        (customer_id, screening_id)
        VALUES ($1, $2)
        RETURNING id"
        values = [@customer_id, @screening_id]

        result = SqlRunner.run(sql, values).first
        @id = result["id"].to_i
    end


    # READ
    def self.all
        sql = "SELECT * FROM tickets"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def self.find(id)
        sql = "SELECT * FROM tickets
        WHERE id = $1"
        values = [id]

        result = SqlRunner.run(sql,values).first
        result ? self.new(result) : nil
    end


    # UPDATE
    def update
        sql = "UPDATE tickets
        SET (customer_id, screening_id)
        = ($1, $2)
        WHERE id = $3"
        values = [@customer_id, @screening_id, @id]
        SqlRunner.run(sql, values)
    end


    # DELETE
    def self.delete_all
        sql = "DELETE FROM tickets"
        SqlRunner.run(sql)
    end

    def delete
        sql = "DELETE FROM tickets
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end
    
    
end
