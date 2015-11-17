#!/usr/bin/env ruby
require 'rubygems'   
require 'csv'
require 'mongo'
require 'net/http'

strings=Array[]
zip=Array[]
cdi=Array[]
response=Array[]
hpcdist=Array[]
lat=Array[]
long=Array[]
suspect=Array[]
city=Array[]
state=Array[]
locid=Array[]

earthquake = CSV.read('earthquake.csv')
CSV.foreach('earthquake.csv') do |row|
  #puts row.inspect
  data=row.inspect.split(',')

  strings.push(data)

end


$i=0

while $i < 175 do
	zip.push(strings[$i][0])
	cdi.push(strings[$i][1])
	response.push(strings[$i][2])
	hpcdist.push(strings[$i][3])
	lat.push(strings[$i][4])
	long.push(strings[$i][5])
	suspect.push(strings[$i][6])
	city.push(strings[$i][7])
	state.push(strings[$i][8])
	locid.push(strings[$i][9])
	zip[$i].slice! "["
	locid[$i].slice! "]"
	zip[$i].slice! '"'
	zip[$i].slice! '"'
	zip[$i].slice! ' '
	
	
	
	$i +=1
end
	
#$connection_variable=Mongo::Client.new([ 'mongodb://heroku_bv2wfp7x:bt1uo8ddu73rs5p6b9nvk5tp4u@ds051534.mongolab.com:51534/heroku_bv2wfp7x' ], :database => 'mongoearthquakes')
#$connection_variable=Mongo::Client.new(['mongodb://heroku_bv2wfp7x:bt1uo8ddu73rs5p6b9nvk5tp4u@ds051534.mongolab.com:51534/heroku_bv2wfp7x'])
#$connection_variable=Mongo::Client.new(:uri=> "mongodb://heroku_bv2wfp7x:bt1uo8ddu73rs5p6b9nvk5tp4u@ds051534.mongolab.com:51534/heroku_bv2wfp7x")

uri='mongodb://heroku_bv2wfp7x:bt1uo8ddu73rs5p6b9nvk5tp4u@ds051534.mongolab.com:51534/heroku_bv2wfp7x'
$connection_variable=Mongo::Client.new(uri)



$connection_variable[:mongoearthquakes].drop
puts "Connected to Mongo DataBase, Inserting data . . . . . "

$j=0
while $j < 175 do
	$connection_variable[:mongoearthquakes].insert_one({"zip"=>zip[$j],"cdi"=>cdi[$j],"response"=>response[$j],"hpcdist"=>hpcdist[$j],"lat"=>lat[$j],"long"=>long[$j],"suspect"=>suspect[$j],"city"=>city[$j],"state"=>state[$j],"locid"=>locid[$j]})
	$j+=1
end

puts "Data Inserted"

puts "Enter the ZIP code [primary key] to retrieve the details"
$qzip=gets.chomp
#$qzip='"'+$qzip+'"'
result=$connection_variable[:mongoearthquakes].find({"zip"=>$qzip},{"_id"=>0})
result.each do |tuple|
    puts tuple
end

puts "Enter the City value [non primary attribute] to retrieve the details"
$qcity=gets.chomp
$qcity=" \""+$qcity+'"'
#puts $qcity
result1=$connection_variable[:mongoearthquakes].find({"city"=>$qcity},{"_id"=>0})
result1.each do |tuple|
	puts tuple
end
