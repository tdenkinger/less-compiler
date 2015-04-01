#!/usr/bin/env ruby

require "listen"

source = ARGV[0]
target = ARGV[1]

listener = Listen.to(source, only: /\.less$/) { |modified, added, removed|
  files = added + modified
  original = files[0]
  original_file = File.basename original
  compiled_file = original_file.gsub(/less$/, "css")
  compiled = File.expand_path  File.join(target, compiled_file)
  source_map = compiled_file + ".map"

  puts "#{Time.now.to_s}\tRecompiling: #{original}"

  # puts "#{Time.now.to_s}\tRecompiling: #{original} to #{compiled} (minified, with source map)"
  # puts "Command: lessc -x --source-map=#{source_map} #{original} > #{compiled}"

  `lessc -x --source-map=#{source_map} #{original} > #{compiled}`
}

listener.start
sleep
