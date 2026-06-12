Gem::Specification.new do |spec|
  spec.name    = "demo"
  spec.version = "0.0.0"
  spec.summary = "BoltFFI-generated Ruby bindings for demo"
  spec.description = "Generated Ruby C-extension bindings for the demo Rust crate, produced by BoltFFI."

  # Source gem: compiled from source at install, ships no prebuilt binary, so it
  # installs on any platform with a Rust toolchain. `boltffi pack ruby` produces
  # the precompiled variant — it vendors a per-arch libdemo_ffi.a and stamps
  # spec.platform (e.g. arm64-darwin) so RubyGems serves each archive only to a
  # matching host. A vendored .a with no platform tag would be served everywhere
  # and fail to link on a mismatched arch.
  spec.platform = Gem::Platform::RUBY

  spec.files = [
    "lib/demo.rb",
    "ext/demo/_native.c",
    "ext/demo/extconf.rb",
  ]

  spec.extensions = ["ext/demo/extconf.rb"]

  spec.required_ruby_version     = ">= 3.1"
  spec.required_rubygems_version = ">= 3.0"
  spec.metadata = { "rubygems_mfa_required" => "true" }
end