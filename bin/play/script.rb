#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__)

require 'card'

Card::CLI.run(*ARGV)

puts "oi"
