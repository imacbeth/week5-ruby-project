require_relative('../db/sql_runner.rb')

class Ticket
  attr_reader :id, :performance_id, :customer_id, :price

  def initialize(options)
    @id = options['id'].to_i if options ['id']
    @performance_id = options['performance_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    (
    performance_id
    )
    VALUES (
    $1
    )
    RETURNING id"
    values = [@performance_id]
    result = SqlRunner.run(sql, values)
    @id = result.first['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    ticket_data = SqlRunner.run(sql)
    return ticket_data.map { |ticket| Ticket.new(ticket) }
  end

  def self.find(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    ticket =  Ticket.new(result.first)
    return ticket
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE tickets
    SET
    (performance_id
    ) =
    (
      $1
    )
    WHERE id = $4"
    values = [@performance_id, @id]
    SqlRunner.run(sql, values)
  end


  def performance_time()
    sql = "SELECT * FROM performances WHERE id = $1"
    values = [@performance_id]
    results = SqlRunner.run(sql, values)
    return Performance.new(results.first).get_formatted_start_time
  end

  def self.map_items(ticket_data)
    result = ticket_data.map { |ticket| Ticket.new( ticket ) }
    return result
  end

end
