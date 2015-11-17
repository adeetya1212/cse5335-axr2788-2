#!/usr/bin/ruby
require 'csv'
require 'pg'
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
$j=0
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
		#city[$i].slice! '"'
	
		
		$i +=1
end
begin


	uri="postgres://oxapsixskqxayk:-s4KvXKAQCYoZnAj2q_pqfhbLz@ec2-54-243-149-147.compute-1.amazonaws.com:5432/dmh20fs26tqp"
	con=PG.connect(uri)
    #con = PG.connect :dbname => 'postgres://oxapsixskqxayk:-s4KvXKAQCYoZnAj2q_pqfhbLz@ec2-54-243-149-147.compute-1.amazonaws.com:5432/dmh20fs26tqp', :user => 'cse5335'
    
    con.exec "DROP TABLE IF EXISTS Earthquake"
    puts "Entering Data in to the Database . . . . "
    con.exec "CREATE TABLE Earthquake(ZIP integer PRIMARY KEY, CDI varchar(15), RESPONSE varchar(15), hpcdist varchar(15),lat varchar(15),long varchar(15),suspect varchar(15),city varchar(30),state varchar(30),locid varchar(30))"
	$k=0
	#puts "INSERT INTO Earthquake VALUES("+'"'+zip[2]
	#puts "\n"
	while $k < 175 do
		con.exec "INSERT INTO Earthquake VALUES("+zip[$k]+","+"'"+cdi[$k]+"'"+","+"'"+response[$k]+"'"+","+"'"+hpcdist[$k]+"'"+","+"'"+lat[$k]+"'"+","+"'"+long[$k]+"'"+","+"'"+suspect[$k]+"'"+","+"'"+city[$k]+"'"+","+"'"+state[$k]+"'"+","+"'"+locid[$k]+"'"+")"
			
		#puts city[$k]
		$k+=1
	end

	puts "Data Entered. . . ."
	puts "Enter the Primary Key [ZIP CODE] to retrieve the details "
	$qzip=gets.chomp

    $rs=con.exec "select * from Earthquake where zip="+$qzip
   
    $rs.each do |row|
      puts "%s %s %s %s %s %s %s %s %s %s" % [ row['zip'], row['cdi'], row['response'], row['hpcdist'], row['lat'], row['long'], row['suspect'], row['city'], row['state'], row['locid']]
    end


    puts "Enter the City Value [NON PRIMARY KEY VALUE] to retrieve the records"
	$qcity=gets.chomp
	$qcity=" "+'"'+$qcity+'"'	
	puts $qcity
	$rs1=con.exec "select * from Earthquake where city= "+"'"+$qcity+"'"
	$rs1.each do |row|
      puts "%s %s %s %s %s %s %s %s %s %s" % [ row['zip'], row['cdi'], row['response'], row['hpcdist'], row['lat'], row['long'], row['suspect'], row['city'], row['state'], row['locid']]
    end
    rescue PG::Error => e

    puts e.message 
    




ensure

    con.close if con
    
end