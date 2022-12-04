#!/usr/bin/env ruby

#/ip firewall address-list
#
def addDom(dom, list)
## validate list and domain
	return "add address=#{dom} comment=\"NGTECH1LTD\" list=#{list}"
end

filename=ARGV[0]
list=ARGV[1]

if filename.nil? or filename.empty? or not File.file?(filename)
	puts "Missing file name or doesn't exist"
	exit 1
end

if list.nil? or list.empty?
	puts "Missing list name"
	exit 2
end

if !list.match(/^[a-zA-Z0-9\-\_]+$/)
	puts "The list name is invalid"
end

puts '/ip firewall address-list'

File.open(filename).readlines.each do |l|
	puts("#{addDom(l.chomp, list)}")
end
