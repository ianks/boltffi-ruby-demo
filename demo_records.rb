#!/usr/bin/env ruby
# frozen_string_literal: true

# Demo script for exercising generated record value classes.
# Constructs ~10 different record classes, asserts attr_reader values,
# and demonstrates error record raise/rescue behavior.

require_relative "lib/demo"

def assert(condition, message)
  raise "Assertion failed: #{message}" unless condition
  puts "  ✓ #{message}"
end

puts "=== BoltFFI Ruby Record Value Classes Demo ==="
puts

# 1. Point (simple 2-field record)
puts "1. Testing Demo::Point (x, y)"
p = Demo::Point.new(3, 4)
assert(p.x == 3, "Point.x == 3")
assert(p.y == 4, "Point.y == 4")
assert(p.is_a?(Demo::Point), "Point is a Demo::Point")
puts

# 2. Color (4-field record with all numeric values)
puts "2. Testing Demo::Color (r, g, b, a)"
c = Demo::Color.new(255, 128, 64, 200)
assert(c.r == 255, "Color.r == 255")
assert(c.g == 128, "Color.g == 128")
assert(c.b == 64, "Color.b == 64")
assert(c.a == 200, "Color.a == 200")
puts

# 3. Event (string + timestamp)
puts "3. Testing Demo::Event (name, timestamp)"
e = Demo::Event.new("user_login", 1234567890)
assert(e.name == "user_login", "Event.name == 'user_login'")
assert(e.timestamp == 1234567890, "Event.timestamp == 1234567890")
puts

# 4. Location (6-field record with mixed types)
puts "4. Testing Demo::Location (id, lat, lng, rating, review_count, is_open)"
loc = Demo::Location.new(42, 37.7749, -122.4194, 4.5, 128, true)
assert(loc.id == 42, "Location.id == 42")
assert(loc.lat == 37.7749, "Location.lat == 37.7749")
assert(loc.lng == -122.4194, "Location.lng == -122.4194")
assert(loc.rating == 4.5, "Location.rating == 4.5")
assert(loc.review_count == 128, "Location.review_count == 128")
assert(loc.is_open == true, "Location.is_open == true")
puts

# 5. ServiceConfig (5-field record with strings)
puts "5. Testing Demo::ServiceConfig (name, retries, region, endpoint, backup_endpoint)"
cfg = Demo::ServiceConfig.new("api-gateway", 3, "us-west-2", "https://api.example.com", "https://backup.example.com")
assert(cfg.name == "api-gateway", "ServiceConfig.name == 'api-gateway'")
assert(cfg.retries == 3, "ServiceConfig.retries == 3")
assert(cfg.region == "us-west-2", "ServiceConfig.region == 'us-west-2'")
assert(cfg.endpoint == "https://api.example.com", "ServiceConfig.endpoint == 'https://api.example.com'")
assert(cfg.backup_endpoint == "https://backup.example.com", "ServiceConfig.backup_endpoint == 'https://backup.example.com'")
puts

# 6. Particle (10-field record with physics data)
puts "6. Testing Demo::Particle (id, x, y, z, vx, vy, vz, mass, charge, active)"
part = Demo::Particle.new(1, 0.5, 1.5, 2.5, 0.1, -0.2, 0.3, 0.001, 1.6, true)
assert(part.id == 1, "Particle.id == 1")
assert(part.x == 0.5, "Particle.x == 0.5")
assert(part.y == 1.5, "Particle.y == 1.5")
assert(part.z == 2.5, "Particle.z == 2.5")
assert(part.vx == 0.1, "Particle.vx == 0.1")
assert(part.vy == -0.2, "Particle.vy == -0.2")
assert(part.vz == 0.3, "Particle.vz == 0.3")
assert(part.mass == 0.001, "Particle.mass == 0.001")
assert(part.charge == 1.6, "Particle.charge == 1.6")
assert(part.active == true, "Particle.active == true")
puts

# 7. SensorReading (9-field record)
puts "7. Testing Demo::SensorReading (sensor_id, timestamp, temperature, humidity, pressure, light, battery, signal_strength, is_valid)"
sensor = Demo::SensorReading.new(101, 1609459200, 22.5, 45, 1013.25, 500, 85, 95, true)
assert(sensor.sensor_id == 101, "SensorReading.sensor_id == 101")
assert(sensor.timestamp == 1609459200, "SensorReading.timestamp == 1609459200")
assert(sensor.temperature == 22.5, "SensorReading.temperature == 22.5")
assert(sensor.humidity == 45, "SensorReading.humidity == 45")
assert(sensor.pressure == 1013.25, "SensorReading.pressure == 1013.25")
assert(sensor.light == 500, "SensorReading.light == 500")
assert(sensor.battery == 85, "SensorReading.battery == 85")
assert(sensor.signal_strength == 95, "SensorReading.signal_strength == 95")
assert(sensor.is_valid == true, "SensorReading.is_valid == true")
puts

# 8. UserProfile (4-field record)
puts "8. Testing Demo::UserProfile (name, age, email, score)"
user = Demo::UserProfile.new("Alice", 30, "alice@example.com", 95.5)
assert(user.name == "Alice", "UserProfile.name == 'Alice'")
assert(user.age == 30, "UserProfile.age == 30")
assert(user.email == "alice@example.com", "UserProfile.email == 'alice@example.com'")
assert(user.score == 95.5, "UserProfile.score == 95.5")
puts

# 9. SearchResult (4-field record)
puts "9. Testing Demo::SearchResult (query, total, next_cursor, max_score)"
result = Demo::SearchResult.new("ruby gems", 1000, "cursor_abc123", 9.8)
assert(result.query == "ruby gems", "SearchResult.query == 'ruby gems'")
assert(result.total == 1000, "SearchResult.total == 1000")
assert(result.next_cursor == "cursor_abc123", "SearchResult.next_cursor == 'cursor_abc123'")
assert(result.max_score == 9.8, "SearchResult.max_score == 9.8")
puts

# 10. Person (2-field record)
puts "10. Testing Demo::Person (name, age)"
person = Demo::Person.new("Bob", 25)
assert(person.name == "Bob", "Person.name == 'Bob'")
assert(person.age == 25, "Person.age == 25")
puts

# 11. Address (3-field record)
puts "11. Testing Demo::Address (street, city, zip)"
addr = Demo::Address.new("123 Main St", "Springfield", "12345")
assert(addr.street == "123 Main St", "Address.street == '123 Main St'")
assert(addr.city == "Springfield", "Address.city == 'Springfield'")
assert(addr.zip == "12345", "Address.zip == '12345'")
puts

# 12. ERROR RECORD: AppError (subclasses StandardError)
puts "12. Testing Demo::AppError (code, message) - StandardError subclass"
assert(Demo::AppError < StandardError, "AppError is a StandardError subclass")

error_obj = Demo::AppError.new(500, "Internal Server Error")
assert(error_obj.code == 500, "AppError.code == 500")
assert(error_obj.message == "Internal Server Error", "AppError.message == 'Internal Server Error'")
assert(error_obj.is_a?(StandardError), "AppError instance is a StandardError")

# Test raise and rescue
begin
  raise Demo::AppError.new(404, "Not Found")
rescue Demo::AppError => e
  assert(e.code == 404, "Rescued AppError.code == 404")
  assert(e.message == "Not Found", "Rescued AppError.message == 'Not Found'")
  assert(e.is_a?(Demo::AppError), "Rescued object is a Demo::AppError")
  assert(e.is_a?(StandardError), "Rescued object is a StandardError")
  puts "  ✓ Successfully raised and rescued Demo::AppError"
end
puts

# 13. Task (3-field record)
puts "13. Testing Demo::Task (title, priority, completed)"
task = Demo::Task.new("Implement feature X", 2, false)
assert(task.title == "Implement feature X", "Task.title == 'Implement feature X'")
assert(task.priority == 2, "Task.priority == 2")
assert(task.completed == false, "Task.completed == false")
puts

puts "=" * 50
puts "demo_records: ALL OK"
