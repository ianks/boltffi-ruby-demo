#!/usr/bin/env ruby
# BoltFFI Ruby opaque class demo — exercises all registered Demo:: classes and methods.
# This script demonstrates GC-safe heap object management and verifies method signatures.

require_relative "./lib/demo"

# Simple test helper: raise if condition is false
def assert(condition, message)
  raise "ASSERT FAILED: #{message}" unless condition
end

puts "=== BoltFFI Demo Classes ==="
puts

# =============================================================================
# 1. Counter — int state with operations (initialize(initial), get, increment, add, reset)
# =============================================================================
puts "1. Counter (initialize(initial), get, increment, add, reset)"
c = Demo::Counter.new(10)
assert c.get == 10, "Counter.get after new(10) should be 10"
puts "  ✓ Counter.new(10).get == 10"

c.increment
assert c.get == 11, "Counter.get after increment should be 11"
puts "  ✓ Counter.increment; .get == 11"

c.add(5)
assert c.get == 16, "Counter.get after add(5) should be 16"
puts "  ✓ Counter.add(5); .get == 16"

c.reset
assert c.get == 0, "Counter.get after reset should be 0"
puts "  ✓ Counter.reset; .get == 0"

# =============================================================================
# 2. SharedCounter — thread-safe counter variant (initialize(initial), get, set, increment, add)
# =============================================================================
puts "\n2. SharedCounter (initialize(initial), get, set, increment, add)"
sc = Demo::SharedCounter.new(5)
assert sc.get == 5, "SharedCounter.get after new(5) should be 5"
puts "  ✓ SharedCounter.new(5).get == 5"

sc.set(20)
assert sc.get == 20, "SharedCounter.get after set(20) should be 20"
puts "  ✓ SharedCounter.set(20); .get == 20"

sc.increment
assert sc.get == 21, "SharedCounter.get after increment should be 21"
puts "  ✓ SharedCounter.increment; .get == 21"

sc.add(4)
assert sc.get == 25, "SharedCounter.get after add(4) should be 25"
puts "  ✓ SharedCounter.add(4); .get == 25"

# =============================================================================
# 3. Accumulator — integer accumulation (initialize(), get, add(amount), reset)
# =============================================================================
puts "\n3. Accumulator (initialize(), get, add(amount), reset)"
acc = Demo::Accumulator.new
initial = acc.get
assert initial.is_a?(Numeric), "Accumulator.get should return a number"
puts "  ✓ Accumulator.new.get returns numeric: #{initial}"

acc.add(10)
after_add = acc.get
assert after_add > initial, "Accumulator.get after add should increase"
puts "  ✓ Accumulator.add(10) changes value (#{initial} -> #{after_add})"

acc.reset
assert acc.get == initial, "Accumulator.get after reset should match initial"
puts "  ✓ Accumulator.reset restores initial value"

# =============================================================================
# 4. AccumulatorSingleThreaded — single-threaded accumulator (initialize(), get, add, reset)
# =============================================================================
# Its mutators (add, reset) take `&mut self`, which the Ruby generator
# intentionally does NOT bind: a Ruby object is a GC-managed handle that's freely
# aliased, so Rust's exclusive-borrow guarantee can't hold. The generator warns
# and skips them (switch the receiver to `&self` + interior mutability to expose
# them), so only the `&self` reader `get` is bound here.
puts "\n4. AccumulatorSingleThreaded (initialize(), get) — &mut self mutators skipped"
acc_st = Demo::AccumulatorSingleThreaded.new
initial_st = acc_st.get
assert initial_st.is_a?(Numeric), "AccumulatorSingleThreaded.get should return a number"
puts "  ✓ AccumulatorSingleThreaded.new.get returns numeric: #{initial_st}"

assert !acc_st.respond_to?(:add), "&mut self method add should NOT be bound"
assert !acc_st.respond_to?(:reset), "&mut self method reset should NOT be bound"
puts "  ✓ &mut self mutators (add, reset) are intentionally not bound"

# =============================================================================
# 5. CounterSingleThreaded — single-threaded counter (initialize(no-arg), get, increment, set)
# =============================================================================
# increment/set take `&mut self` and are skipped for the same reason as #4.
puts "\n5. CounterSingleThreaded (initialize(), get) — &mut self mutators skipped"
cst = Demo::CounterSingleThreaded.new
initial_cst = cst.get
assert initial_cst.is_a?(Integer), "CounterSingleThreaded.get should return an integer"
puts "  ✓ CounterSingleThreaded.new.get returns integer: #{initial_cst}"

assert !cst.respond_to?(:increment), "&mut self method increment should NOT be bound"
assert !cst.respond_to?(:set), "&mut self method set should NOT be bound"
puts "  ✓ &mut self mutators (increment, set) are intentionally not bound"

# =============================================================================
# 6. Inventory — item count management (initialize(), count, capacity, add(name))
# =============================================================================
puts "\n6. Inventory (initialize(), count, capacity, add(name))"
inv = Demo::Inventory.new
count_initial = inv.count
capacity = inv.capacity
assert count_initial.is_a?(Integer) && capacity.is_a?(Integer), "Inventory count/capacity should be integers"
puts "  ✓ Inventory.new: count=#{count_initial}, capacity=#{capacity}"

# add(&self, String) -> bool; Rust bool maps to Ruby true/false
ret = inv.add("widget")
assert ret == true || ret == false, "Inventory.add should return a boolean"
puts "  ✓ Inventory.add('widget') returned: #{ret}"

# =============================================================================
# 7. MathUtils — math operations (initialize(precision), round(val), add(a, b), clamp(val, min, max))
# =============================================================================
# round(&self, value) is an instance method; add/clamp are static (associated fns
# with no `self`) and bind as class (singleton) methods — called on the class itself.
puts "\n7. MathUtils (initialize(precision), round(val) instance; add(a, b), clamp(val, min, max) static)"
mu = Demo::MathUtils.new(2)
result_round = mu.round(3.7)
assert result_round.is_a?(Numeric), "MathUtils.round should return a number"
puts "  ✓ MathUtils.new(2).round(3.7) = #{result_round}"

# Static methods live on the class, not the instance.
assert !mu.respond_to?(:add), "add is static — must NOT be an instance method"
result_add = Demo::MathUtils.add(5, 7)
assert result_add == 12, "MathUtils.add(5, 7) should equal 12, got #{result_add}"
puts "  ✓ Demo::MathUtils.add(5, 7) = #{result_add}"

result_clamp = Demo::MathUtils.clamp(5.0, 0.0, 10.0)
assert result_clamp.is_a?(Numeric), "MathUtils.clamp should return a number"
assert result_clamp >= 0.0 && result_clamp <= 10.0, "MathUtils.clamp result should be within bounds"
puts "  ✓ Demo::MathUtils.clamp(5.0, 0.0, 10.0) = #{result_clamp} (within bounds)"

# =============================================================================
# 8. DataStore — bulk data management (initialize(), len, is_empty, add_parts(x, y, timestamp), sum, foreach(&block))
# =============================================================================
puts "\n8. DataStore (initialize(), len, is_empty, sum, add_parts(x, y, timestamp), foreach(&block))"
ds = Demo::DataStore.new
is_empty_initial = ds.is_empty  # Rust bool maps to Ruby true/false
len_initial = ds.len
assert is_empty_initial == true, "DataStore.is_empty should be true after new"
assert len_initial == 0, "DataStore.len should be 0 after new"
puts "  ✓ DataStore.new: is_empty=#{is_empty_initial}, len=#{len_initial}"

# add_parts expects (x: f64, y: f64, timestamp: i64)
ds.add_parts(10.5, 20.3, 1000)
is_empty_after = ds.is_empty
len_after = ds.len
sum_val = ds.sum
assert sum_val.is_a?(Numeric), "DataStore.sum should be a number"
puts "  ✓ DataStore.add_parts(10.5, 20.3, 1000): is_empty=#{is_empty_after}, len=#{len_after}, sum=#{sum_val}"

# =============================================================================
# 9. EventBus — simple event emission (initialize(), emit_value(val))
# =============================================================================
puts "\n9. EventBus (initialize(), emit_value(val))"
eb = Demo::EventBus.new
result = eb.emit_value(42)
# emit_value returns void (Qnil)
assert result.nil?, "EventBus.emit_value should return nil"
puts "  ✓ EventBus.new.emit_value(42) completed (returned nil)"

# =============================================================================
# 10. MixedRecordService — record retrieval (initialize(label), get_label(), stored_count())
# =============================================================================
puts "\n10. MixedRecordService (initialize(label), get_label(), stored_count())"
# initialize expects a string (label, not code)
mrs = Demo::MixedRecordService.new("RECORD_LABEL")
label = mrs.get_label
assert label.is_a?(String), "MixedRecordService.get_label should return a string"
count = mrs.stored_count
assert count.is_a?(Integer), "MixedRecordService.stored_count should return an integer"
puts "  ✓ MixedRecordService.new('RECORD_LABEL'): label='#{label}', count=#{count}"

# =============================================================================
# 11. StateHolder — state management (initialize(label), get_label, get_value, set_value,
#                   increment, item_count, add_item, clear)
# =============================================================================
# StateHolder mixes `&self` readers (get_label, get_value, item_count) with
# `&mut self` mutators (set_value, increment, add_item, remove_last, clear,
# transform_value). Only the readers are bound; the mutators are skipped for the
# same GC-handle aliasing reason as #4.
puts "\n11. StateHolder (initialize(label), get_label, get_value, item_count) — &mut self mutators skipped"
sh = Demo::StateHolder.new("test_label")
assert sh.get_label == "test_label", "StateHolder.get_label should match initialization"
puts "  ✓ StateHolder.new('test_label').get_label == 'test_label'"

initial_value = sh.get_value
assert initial_value.is_a?(Integer), "StateHolder.get_value should return an integer"
puts "  ✓ StateHolder.get_value returns integer: #{initial_value}"

assert sh.item_count == 0, "StateHolder.item_count should be 0 for a fresh holder"
puts "  ✓ StateHolder.item_count == 0"

[:set_value, :increment, :add_item, :remove_last, :clear].each do |m|
  assert !sh.respond_to?(m), "&mut self method #{m} should NOT be bound"
end
puts "  ✓ &mut self mutators (set_value, increment, add_item, remove_last, clear) are intentionally not bound"

# =============================================================================
# 12. ConstructorCoverageMatrix — constructor variant coverage (initialize(), constructor_variant,
#                                  summary, payload_checksum, vector_count)
# =============================================================================
puts "\n12. ConstructorCoverageMatrix (initialize(), constructor_variant, summary, payload_checksum, vector_count)"
ccm = Demo::ConstructorCoverageMatrix.new
variant = ccm.constructor_variant
assert variant.is_a?(String), "ConstructorCoverageMatrix.constructor_variant should return a string"
puts "  ✓ ConstructorCoverageMatrix.constructor_variant = #{variant.inspect}"

summary = ccm.summary
assert summary.is_a?(String), "ConstructorCoverageMatrix.summary should return a string"
puts "  ✓ ConstructorCoverageMatrix.summary = #{summary.inspect}"

checksum = ccm.payload_checksum
assert checksum.is_a?(Integer), "ConstructorCoverageMatrix.payload_checksum should return an integer"
puts "  ✓ ConstructorCoverageMatrix.payload_checksum = #{checksum}"

vcount = ccm.vector_count
assert vcount.is_a?(Integer), "ConstructorCoverageMatrix.vector_count should return an integer"
puts "  ✓ ConstructorCoverageMatrix.vector_count = #{vcount}"

# =============================================================================
# GC Safety Demonstration: Create objects in a loop, let them go out of scope, trigger GC
# =============================================================================
puts "\n=== GC Safety Test ==="
puts "Creating 100 Counter objects in loop and letting them go out of scope..."
100.times do |i|
  temp = Demo::Counter.new(i)
  temp.increment
  # Object goes out of scope here; should be eligible for GC
end
puts "  ✓ Created and discarded 100 Counter objects"

puts "Running GC.start to collect and finalize..."
GC.start
puts "  ✓ GC.start completed successfully (no segfault)"

puts "\nCreating and discarding complex objects (Inventory, StateHolder)..."
50.times do
  inv_temp = Demo::Inventory.new
  inv_temp.add("item_name")

  sh_temp = Demo::StateHolder.new("gc_test")
  sh_temp.get_value
end
puts "  ✓ Created and discarded 50 Inventory + 50 StateHolder objects"

GC.start
puts "  ✓ GC.start completed successfully"

# =============================================================================
# Final confirmation
# =============================================================================
puts "\n" + "=" * 70
puts "demo_classes: ALL OK"
puts "=" * 70
puts "\nSummary:"
puts "  - 12 opaque classes exercised"
puts "  - &self/static methods called and verified"
puts "  - &mut self methods confirmed intentionally unbound (single-threaded classes)"
puts "  - All type signatures validated"
puts "  - GC finalization demonstrated with 150+ temporary objects"
