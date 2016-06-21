notification :terminal_notifier

rspec_options = {
  all_after_pass: false,
  cmd: 'rspec spec',
  failed_mode: :focus
}

clearing :on

guard :rspec, rspec_options do
  require 'ostruct'

  # Generic Ruby apps
  rspec = OpenStruct.new
  rspec.spec = ->(m) { "spec/#{m}_spec.rb" }
  rspec.spec_dir = 'spec'
  rspec.spec_helper = 'spec/spec_helper.rb'

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/mifiel/(.+)\.rb$}) do |m|
    "spec/mifiel/#{m[1]}_spec.rb"
  end
  watch(%r{^lib/mifiel/(.+)\.rb$}) do |m|
    "spec/mifiel/integration/#{m[1]}_spec.rb"
  end
  watch(rspec.spec_helper) { rspec.spec_dir }
end

rubocop_opts = {
  all_on_start: false,
  cli: '--format html -o rubocop.html'
}
guard :rubocop, rubocop_opts do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
