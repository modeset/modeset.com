begin
  require 'ci/reporter/rake/rspec'
rescue LoadError
  puts 'Skipping CI Reporter'
end
