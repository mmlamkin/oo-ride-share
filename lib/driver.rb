require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id
    attr_accessor :status, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = input[:id]
      @name = input[:name]
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]

      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end

      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end

      return average
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def total_revenue
      total_rev = 0
      @trips.each do |trip|
        total_rev += (trip.cost - 1.65) * 0.80
      end
      return total_rev.round(2)
    end

    def avg_rev
      total_time = 0
      @trips.each do |trip|
        total_time += (trip.trip_length)
      end
      average = total_revenue / (total_time / 60 / 60)

      return average.round(2)
    end

    def in_progress(new_trip)
      @status = :UNAVAILABLE
      add_trip(new_trip)
    end
  end
end
