#!/usr/bin/env ruby
# frozen_string_literal: true

# BoltFFI Ruby Extension Demo
# Exercise scalar/string functions with comprehensive assertions

require_relative "lib/demo"

puts "demo_functions: Starting comprehensive test suite"
puts

# Track test results
tests_passed = 0

def test(description, result, expected)
  if result == expected
    puts "  #{description}  OK"
    return true
  else
    puts "  #{description}  FAILED: expected #{expected}, got #{result}"
    return false
  end
end

# ── Integer functions (i32) ──────────────────────────────────────────────────
puts "=== Integer (i32) Functions ==="

tests_passed += 1 if test("echo_i32(42)", Demo.echo_i32(42), 42)
tests_passed += 1 if test("echo_i32(-100)", Demo.echo_i32(-100), -100)
tests_passed += 1 if test("echo_i32(0)", Demo.echo_i32(0), 0)

tests_passed += 1 if test("add_i32(2, 3)", Demo.add_i32(2, 3), 5)
tests_passed += 1 if test("add_i32(100, -50)", Demo.add_i32(100, -50), 50)
tests_passed += 1 if test("add_i32(-10, -20)", Demo.add_i32(-10, -20), -30)

tests_passed += 1 if test("add(10, 20)", Demo.add(10, 20), 30)
tests_passed += 1 if test("add(5, -3)", Demo.add(5, -3), 2)

# ── Float functions (f64) ────────────────────────────────────────────────────
puts
puts "=== Float (f64) Functions ==="

result = Demo.echo_f64(3.14)
tests_passed += 1 if test("echo_f64(3.14)", (result - 3.14).abs < 0.001, true)

result = Demo.echo_f64(0.0)
tests_passed += 1 if test("echo_f64(0.0)", (result - 0.0).abs < 0.001, true)

result = Demo.echo_f64(-2.71)
tests_passed += 1 if test("echo_f64(-2.71)", (result - (-2.71)).abs < 0.001, true)

result = Demo.add_f64(2.5, 3.5)
tests_passed += 1 if test("add_f64(2.5, 3.5)", (result - 6.0).abs < 0.001, true)

result = Demo.add_f64(1.0, -0.5)
tests_passed += 1 if test("add_f64(1.0, -0.5)", (result - 0.5).abs < 0.001, true)

result = Demo.multiply(2.0, 3.5)
tests_passed += 1 if test("multiply(2.0, 3.5)", (result - 7.0).abs < 0.001, true)

result = Demo.multiply(5.0, 2.0)
tests_passed += 1 if test("multiply(5.0, 2.0)", (result - 10.0).abs < 0.001, true)

# ── Float functions (f32) ────────────────────────────────────────────────────
puts
puts "=== Float (f32) Functions ==="

result = Demo.echo_f32(1.5)
tests_passed += 1 if test("echo_f32(1.5)", (result - 1.5).abs < 0.01, true)

result = Demo.echo_f32(0.0)
tests_passed += 1 if test("echo_f32(0.0)", (result - 0.0).abs < 0.01, true)

result = Demo.add_f32(1.5, 2.5)
tests_passed += 1 if test("add_f32(1.5, 2.5)", (result - 4.0).abs < 0.01, true)

result = Demo.add_f32(0.5, 0.25)
tests_passed += 1 if test("add_f32(0.5, 0.25)", (result - 0.75).abs < 0.01, true)

# ── Boolean functions ────────────────────────────────────────────────────────
puts
puts "=== Boolean Functions ==="

# Rust bool maps to Ruby true/false (params via RB_TEST, returns via Qtrue/Qfalse).
tests_passed += 1 if test("echo_bool(true)", Demo.echo_bool(true), true)
tests_passed += 1 if test("echo_bool(false)", Demo.echo_bool(false), false)

tests_passed += 1 if test("negate_bool(true)", Demo.negate_bool(true), false)
tests_passed += 1 if test("negate_bool(false)", Demo.negate_bool(false), true)

# ── String functions ─────────────────────────────────────────────────────────
puts
puts "=== String Functions ==="

tests_passed += 1 if test("echo_string('hello')", Demo.echo_string("hello"), "hello")
tests_passed += 1 if test("echo_string('')", Demo.echo_string(""), "")
tests_passed += 1 if test("echo_string('test')", Demo.echo_string("test"), "test")

tests_passed += 1 if test("concat_strings('hello', ' world')",
                         Demo.concat_strings("hello", " world"),
                         "hello world")
tests_passed += 1 if test("concat_strings('a', 'b')",
                         Demo.concat_strings("a", "b"),
                         "ab")
tests_passed += 1 if test("concat_strings('', 'foo')",
                         Demo.concat_strings("", "foo"),
                         "foo")

tests_passed += 1 if test("string_length('hello')", Demo.string_length("hello"), 5)
tests_passed += 1 if test("string_length('')", Demo.string_length(""), 0)
tests_passed += 1 if test("string_length('test')", Demo.string_length("test"), 4)

tests_passed += 1 if test("string_is_empty('hello')", Demo.string_is_empty("hello"), false)
tests_passed += 1 if test("string_is_empty('')", Demo.string_is_empty(""), true)
tests_passed += 1 if test("string_is_empty('a')", Demo.string_is_empty("a"), false)

# ── No-op function ───────────────────────────────────────────────────────────
puts
puts "=== Special Functions ==="

result = Demo.noop()
tests_passed += 1 if test("noop()", result.nil?, true)

# ── Summary ──────────────────────────────────────────────────────────────────
puts
puts "=" * 60
puts "Test Summary:"
puts "  Passed: #{tests_passed}"
puts "=" * 60

if tests_passed == 36
  puts "demo_functions: ALL OK"
  exit 0
else
  puts "demo_functions: INCOMPLETE (#{tests_passed}/36 tests passed)"
  exit 1
end
