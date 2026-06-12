# BoltFFI Ruby target — end-to-end demo runner.
# Runs every feature-slice demo against the statically-linked C extension.
#
#   ruby run_all.rb
#
# Each slice requires the same compiled `demo_native` (the Rust staticlib linked
# in) and exercises one part of the generated surface.

dir = __dir__
slices = %w[demo_functions.rb demo_enums.rb demo_records.rb demo_classes.rb demo_ractor.rb]

puts "=" * 70
puts "BoltFFI Ruby target — end-to-end demo"
puts "extension: #{dir}/lib/demo_native.bundle (Rust staticlib statically linked)"
puts "=" * 70

failures = []
slices.each do |slice|
  puts "\n### #{slice}"
  ok = system(RbConfig.ruby, File.join(dir, slice))
  failures << slice unless ok
end

puts "\n" + ("=" * 70)
if failures.empty?
  puts "ALL DEMO SLICES PASSED ✅  (#{slices.join(', ')})"
else
  puts "FAILED slices: #{failures.join(', ')} ❌"
  exit 1
end
