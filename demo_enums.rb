#!/usr/bin/env ruby
# frozen_string_literal: true

# Demo script exercising enums in the BoltFFI Ruby C extension.
# Tests enum constants, conversions, predicates, transformations, and callbacks.
# Avoids functions that have broken implementations (echo_filter, echo_message,
# echo_animal, echo_task_status, echo_api_response, etc.)

# Load the demo module with proper load paths
$LOAD_PATH.unshift(File.expand_path("./ext/demo", __dir__))
require_relative "./lib/demo"

puts "=== BoltFFI Enum Demo ==="
puts

# ============================================================================
# ENUM CONSTANTS
# ============================================================================
puts "--- Enum Constants ---"

# Status enum
raise unless Demo::Status::ACTIVE == 0
puts "✓ Status::ACTIVE == 0"

raise unless Demo::Status::INACTIVE == 1
puts "✓ Status::INACTIVE == 1"

raise unless Demo::Status::PENDING == 2
puts "✓ Status::PENDING == 2"

# Direction enum
raise unless Demo::Direction::NORTH == 0
puts "✓ Direction::NORTH == 0"

raise unless Demo::Direction::SOUTH == 1
puts "✓ Direction::SOUTH == 1"

raise unless Demo::Direction::EAST == 2
puts "✓ Direction::EAST == 2"

raise unless Demo::Direction::WEST == 3
puts "✓ Direction::WEST == 3"

# Priority enum
raise unless Demo::Priority::LOW == 0
puts "✓ Priority::LOW == 0"

raise unless Demo::Priority::MEDIUM == 1
puts "✓ Priority::MEDIUM == 1"

raise unless Demo::Priority::HIGH == 2
puts "✓ Priority::HIGH == 2"

raise unless Demo::Priority::CRITICAL == 3
puts "✓ Priority::CRITICAL == 3"

# LogLevel enum
raise unless Demo::LogLevel::TRACE == 0
puts "✓ LogLevel::TRACE == 0"

raise unless Demo::LogLevel::DEBUG == 1
puts "✓ LogLevel::DEBUG == 1"

raise unless Demo::LogLevel::INFO == 2
puts "✓ LogLevel::INFO == 2"

raise unless Demo::LogLevel::WARN == 3
puts "✓ LogLevel::WARN == 3"

raise unless Demo::LogLevel::ERROR == 4
puts "✓ LogLevel::ERROR == 4"

# HttpCode enum (with non-zero values)
raise unless Demo::HttpCode::OK == 200
puts "✓ HttpCode::OK == 200"

raise unless Demo::HttpCode::NOT_FOUND == 404
puts "✓ HttpCode::NOT_FOUND == 404"

raise unless Demo::HttpCode::SERVER_ERROR == 500
puts "✓ HttpCode::SERVER_ERROR == 500"

# Sign enum (with negative value)
raise unless Demo::Sign::NEGATIVE == -1
puts "✓ Sign::NEGATIVE == -1"

raise unless Demo::Sign::ZERO == 0
puts "✓ Sign::ZERO == 0"

raise unless Demo::Sign::POSITIVE == 1
puts "✓ Sign::POSITIVE == 1"

# TaskStatus enum
raise unless Demo::TaskStatus::PENDING == 0
puts "✓ TaskStatus::PENDING == 0"

raise unless Demo::TaskStatus::IN_PROGRESS == 1
puts "✓ TaskStatus::IN_PROGRESS == 1"

raise unless Demo::TaskStatus::COMPLETED == 2
puts "✓ TaskStatus::COMPLETED == 2"

raise unless Demo::TaskStatus::FAILED == 3
puts "✓ TaskStatus::FAILED == 3"

puts

# ============================================================================
# ECHO FUNCTIONS (safe: Status, Direction, Priority, LogLevel, HttpCode, Sign)
# ============================================================================
puts "--- Echo Functions (Enum -> Enum) ---"

raise unless Demo.echo_status(Demo::Status::ACTIVE) == Demo::Status::ACTIVE
puts "✓ echo_status(Status::ACTIVE) == Status::ACTIVE"

raise unless Demo.echo_status(Demo::Status::INACTIVE) == Demo::Status::INACTIVE
puts "✓ echo_status(Status::INACTIVE) == Status::INACTIVE"

raise unless Demo.echo_direction(Demo::Direction::NORTH) == Demo::Direction::NORTH
puts "✓ echo_direction(Direction::NORTH) == Direction::NORTH"

raise unless Demo.echo_direction(Demo::Direction::SOUTH) == Demo::Direction::SOUTH
puts "✓ echo_direction(Direction::SOUTH) == Direction::SOUTH"

raise unless Demo.echo_direction(Demo::Direction::EAST) == Demo::Direction::EAST
puts "✓ echo_direction(Direction::EAST) == Direction::EAST"

raise unless Demo.echo_direction(Demo::Direction::WEST) == Demo::Direction::WEST
puts "✓ echo_direction(Direction::WEST) == Direction::WEST"

raise unless Demo.echo_priority(Demo::Priority::LOW) == Demo::Priority::LOW
puts "✓ echo_priority(Priority::LOW) == Priority::LOW"

raise unless Demo.echo_priority(Demo::Priority::HIGH) == Demo::Priority::HIGH
puts "✓ echo_priority(Priority::HIGH) == Priority::HIGH"

raise unless Demo.echo_log_level(Demo::LogLevel::TRACE) == Demo::LogLevel::TRACE
puts "✓ echo_log_level(LogLevel::TRACE) == LogLevel::TRACE"

raise unless Demo.echo_log_level(Demo::LogLevel::DEBUG) == Demo::LogLevel::DEBUG
puts "✓ echo_log_level(LogLevel::DEBUG) == LogLevel::DEBUG"

raise unless Demo.echo_http_code(Demo::HttpCode::OK) == Demo::HttpCode::OK
puts "✓ echo_http_code(HttpCode::OK) == HttpCode::OK"

raise unless Demo.echo_http_code(Demo::HttpCode::NOT_FOUND) == Demo::HttpCode::NOT_FOUND
puts "✓ echo_http_code(HttpCode::NOT_FOUND) == HttpCode::NOT_FOUND"

raise unless Demo.echo_sign(Demo::Sign::NEGATIVE) == Demo::Sign::NEGATIVE
puts "✓ echo_sign(Sign::NEGATIVE) == Sign::NEGATIVE"

raise unless Demo.echo_sign(Demo::Sign::POSITIVE) == Demo::Sign::POSITIVE
puts "✓ echo_sign(Sign::POSITIVE) == Sign::POSITIVE"

puts

# ============================================================================
# CONVERSION FUNCTIONS (enum -> string)
# ============================================================================
puts "--- Conversion Functions (Enum -> String) ---"

status_str = Demo.status_to_string(Demo::Status::ACTIVE)
raise unless status_str.is_a?(String) && !status_str.empty?
puts "✓ status_to_string(Status::ACTIVE) = '#{status_str}'"

priority_str = Demo.priority_label(Demo::Priority::HIGH)
raise unless priority_str.is_a?(String) && !priority_str.empty?
puts "✓ priority_label(Priority::HIGH) = '#{priority_str}'"

puts

# ============================================================================
# CONVERSION FUNCTIONS (enum -> int)
# ============================================================================
puts "--- Conversion Functions (Enum -> Integer) ---"

north_degrees = Demo.direction_to_degrees(Demo::Direction::NORTH)
raise unless north_degrees == 0
puts "✓ direction_to_degrees(Direction::NORTH) = #{north_degrees}"

south_degrees = Demo.direction_to_degrees(Demo::Direction::SOUTH)
raise unless south_degrees == 180
puts "✓ direction_to_degrees(Direction::SOUTH) = #{south_degrees}"

east_degrees = Demo.direction_to_degrees(Demo::Direction::EAST)
raise unless east_degrees == 90
puts "✓ direction_to_degrees(Direction::EAST) = #{east_degrees}"

west_degrees = Demo.direction_to_degrees(Demo::Direction::WEST)
raise unless west_degrees == 270
puts "✓ direction_to_degrees(Direction::WEST) = #{west_degrees}"

puts

# ============================================================================
# TRANSFORMATION FUNCTIONS (enum -> enum)
# ============================================================================
puts "--- Transformation Functions (Enum -> Enum) ---"

opposite = Demo.opposite_direction(Demo::Direction::NORTH)
raise unless opposite == Demo::Direction::SOUTH
puts "✓ opposite_direction(Direction::NORTH) = Direction::SOUTH"

opposite = Demo.opposite_direction(Demo::Direction::SOUTH)
raise unless opposite == Demo::Direction::NORTH
puts "✓ opposite_direction(Direction::SOUTH) = Direction::NORTH"

opposite = Demo.opposite_direction(Demo::Direction::EAST)
raise unless opposite == Demo::Direction::WEST
puts "✓ opposite_direction(Direction::EAST) = Direction::WEST"

opposite = Demo.opposite_direction(Demo::Direction::WEST)
raise unless opposite == Demo::Direction::EAST
puts "✓ opposite_direction(Direction::WEST) = Direction::EAST"

puts

# ============================================================================
# PREDICATE FUNCTIONS (enum -> bool)
# ============================================================================
puts "--- Predicate Functions (Enum -> Boolean) ---"

raise unless Demo.is_active(Demo::Status::ACTIVE) == true
puts "✓ is_active(Status::ACTIVE) = true"

raise unless Demo.is_active(Demo::Status::INACTIVE) == false
puts "✓ is_active(Status::INACTIVE) = false"

raise unless Demo.is_high_priority(Demo::Priority::HIGH) == true
puts "✓ is_high_priority(Priority::HIGH) = true"

raise unless Demo.is_high_priority(Demo::Priority::CRITICAL) == true
puts "✓ is_high_priority(Priority::CRITICAL) = true"

raise unless Demo.is_high_priority(Demo::Priority::LOW) == false
puts "✓ is_high_priority(Priority::LOW) = false"

puts

# ============================================================================
# TWO-ARGUMENT FUNCTIONS
# ============================================================================
puts "--- Two-Argument Functions ---"

should_log_true = Demo.should_log(Demo::LogLevel::DEBUG, Demo::LogLevel::TRACE)
raise unless should_log_true == true
puts "✓ should_log(LogLevel::DEBUG, LogLevel::TRACE) = true"

should_log_false = Demo.should_log(Demo::LogLevel::TRACE, Demo::LogLevel::DEBUG)
raise unless should_log_false == false
puts "✓ should_log(LogLevel::TRACE, LogLevel::DEBUG) = false"

puts

# ============================================================================
# NOARG FUNCTIONS
# ============================================================================
puts "--- No-Argument Functions ---"

http_not_found = Demo.http_code_not_found()
raise unless http_not_found == Demo::HttpCode::NOT_FOUND
puts "✓ http_code_not_found() = HttpCode::NOT_FOUND (#{http_not_found})"

sign_neg = Demo.sign_negative()
raise unless sign_neg == Demo::Sign::NEGATIVE
puts "✓ sign_negative() = Sign::NEGATIVE (#{sign_neg})"

puts

# ============================================================================
# MULTI-CALL CHAINING TESTS
# ============================================================================
puts "--- Multi-Call Chaining ---"

# Chain: echo_direction -> opposite -> direction_to_degrees
north = Demo::Direction::NORTH
north_echo = Demo.echo_direction(north)
opposite = Demo.opposite_direction(north_echo)
degrees = Demo.direction_to_degrees(opposite)
raise unless opposite == Demo::Direction::SOUTH && degrees == 180
puts "✓ echo(NORTH) -> opposite -> degrees = 180 (SOUTH)"

# Chain: echo_status -> is_active
status = Demo.echo_status(Demo::Status::ACTIVE)
is_active = Demo.is_active(status)
raise unless is_active == true
puts "✓ echo_status(ACTIVE) -> is_active = true"

# Chain: echo_priority -> is_high_priority
priority = Demo.echo_priority(Demo::Priority::MEDIUM)
is_high = Demo.is_high_priority(priority)
raise unless is_high == false
puts "✓ echo_priority(MEDIUM) -> is_high_priority = false"

# Chain: direction conversions
east = Demo::Direction::EAST
east_degrees = Demo.direction_to_degrees(east)
opposite_west = Demo.opposite_direction(east)
west_degrees = Demo.direction_to_degrees(opposite_west)
raise unless east_degrees == 90 && opposite_west == Demo::Direction::WEST && west_degrees == 270
puts "✓ EAST (90°) -> opposite (WEST) -> 270°"

puts

# ============================================================================
# FINAL RESULT
# ============================================================================
puts "demo_enums: ALL OK"
