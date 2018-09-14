# frozen_string_literal: true

require 'bundler/gem_tasks'

task :minitest do
  test = File.expand_path('tests', __dir__)
  $LOAD_PATH.unshift(test) unless $LOAD_PATH.include?(test)

  options = {}
  ARGV.shift
  ARGV.shift
  OptionParser.new do |opts|
    opts.banner = 'Usage: rake minitest [options]'
    opts.on('--filename FILENAME') do |v|
      options[:filename] = v
    end
  end.parse!

  require 'minitest/reporters'
  Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

  files = Dir.glob("./tests/**/#{options[:filename] || '*.rb'}")
  ARGV.concat(files).each { |file| require file }
  require 'minitest/autorun'
end

task default: :minitest
