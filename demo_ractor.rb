#!/usr/bin/env ruby
# frozen_string_literal: true

# BoltFFI Ruby Extension Demo — Ractor safety
#
# The generated extension calls `rb_ext_ractor_safe(true)` in `Init_demo_native`
# (driven by `ractor_safe = true` in boltffi.toml). That declaration is what makes
# the assertions below pass: invoking a method from a C extension that has NOT
# been marked Ractor-safe raises `Ractor::UnsafeError` the moment it runs inside a
# non-main Ractor. So a green run here is a live proof the flag took effect — not
# just that the binding loaded.

require_relative "lib/demo"

puts "demo_ractor: Verifying the extension is callable from non-main Ractors"
puts

tests_passed = 0

def test(description, result, expected)
  if result == expected
    puts "  #{description}  OK"
    true
  else
    puts "  #{description}  FAILED: expected #{expected}, got #{result}"
    false
  end
end

# ── Pure functions inside a Ractor ────────────────────────────────────────────
puts "=== Module functions in a non-main Ractor ==="

# Integers are deeply immutable, so they cross the Ractor boundary by copy with no
# sharing concerns — the only thing under test is whether the C call is permitted.
sum = Ractor.new { Demo.add_i32(2, 3) }.value
tests_passed += 1 if test("Ractor { Demo.add_i32(2, 3) }", sum, 5)

echoed = Ractor.new { Demo.echo_i32(-100) }.value
tests_passed += 1 if test("Ractor { Demo.echo_i32(-100) }", echoed, -100)

# ── Concurrent fan-out across many Ractors ────────────────────────────────────
puts "\n=== Concurrent calls across many Ractors ==="

ractors = (1..16).map { |n| Ractor.new(n) { |x| Demo.add_i32(x, x) } }
doubled = ractors.map(&:value)
tests_passed += 1 if test("16 Ractors each Demo.add_i32(n, n)", doubled, (1..16).map { |n| n * 2 })

puts
puts "=" * 60
puts "Test Summary:"
puts "  Passed: #{tests_passed}"
puts "=" * 60

if tests_passed == 3
  puts "demo_ractor: ALL OK"
  exit 0
else
  puts "demo_ractor: INCOMPLETE (#{tests_passed}/3 tests passed)"
  exit 1
end
