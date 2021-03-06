require_relative('../db/sql_runner.rb')
require_relative('./performance.rb')

class Show

  attr_reader :id, :name, :type

  def initialize(options)
    @id = options['id'].to_i if options ['id']
    @name = options['name']
    @type = options['type']
  end

  def save()
    sql = "INSERT INTO shows
    (
    name, type
    )
    VALUES (
      $1, $2
      )
    RETURNING *"
    values = [@name, @type]
    result = SqlRunner.run(sql, values)
    @id = result.first['id'].to_i()
  end

  def self.delete_all()
    sql = "DELETE FROM shows"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM shows"
    show_data = SqlRunner.run(sql)
    return show_data.map { |show| Show.new(show) }
  end

  def delete(id)
    sql = "DELETE FROM shows WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE shows
    SET (name, type) = ($1, $2)
    WHERE id = $3"
    values = [@name, @type, @id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM shows WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    show = Show.new(result.first)
    return show
  end

  def performances()
    sql = "SELECT * FROM performances WHERE show_id = $1"
    values = [@id]
    performances = SqlRunner.run(sql, values)
    return performances.map { |performance_hash| Performance.new(performance_hash) }
  end

  def total_show_takings()
    performances_of_show = performances()
    total = 0
    performances_of_show.each do |performance|
    total += (performance.price * performance.tickets)
    end
    return total
  end
end
