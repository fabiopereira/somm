require 'csv'
require 'date'

class Events
	def initialize(events) 
		@events = events
	end

	def of_type type
		Events.new @events.select { |e| e.type == type}
	end

	def uniq_types
		all.map { |e| e.type }.uniq
	end

	def count
		@events.count
	end

	def frequency_by_day_of_type type
		days = (all.last.date - all.first.date).to_i
		event_count = of_type(type).count
		days / event_count
	end

	def print_frequency_by_day_of_type type
		f = frequency_by_day_of_type type
		"One event of type #{type} every #{f} days (on average)"
	end

	def all
		@events
	end
end

class Event
	attr_accessor :id
	attr_accessor :date
	attr_accessor :type_s
	attr_accessor :tags

	def to_s
		"#{@id},#{@date},#{@type},#{@tags}"
	end

	def type
		type_s.downcase.to_sym
	end
end

events_array = CSV.read('events.csv').map do |row|
  e = Event.new
  e.id = row[0]
  e.date = DateTime.strptime("20#{row[1]}#{row[2]}", '%Y%m%d%H')
  e.type_s = row[3]
  e.tags = row[4].split(' ') if row[4]
  e
end

events = Events.new events_array

# Event count by type
# puts events.of_type(:s).count
# puts events.of_type(:f).count

puts events.print_frequency_by_day_of_type :s

# puts events.all.map { |e| e.type_s }.uniq



