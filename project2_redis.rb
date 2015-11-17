require 'net/http'
require 'uri'
require 'redis'
require 'csv'

#def open(url)
 # Net::HTTP.get(URI.parse(url))
#end

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
	$i +=1
end

$k=0
while $k < 175 do

	zip[$k].slice! "["
	locid[$k].slice! "]"
	zip[$k].slice! '"'
	zip[$k].slice! '"'
	zip[$k].slice! ' '
	#puts zip[$k]
	$k+=1

end

$acdi="cdi"
$aresponse="response"
$ahpcdist="hpcdist"
$alat="lat"
$along="long"
$asuspect="suspect"
$acity="city"
$astate="state"
$alocid="locid"


$j=0
#$redis = Redis.new(:host=>'localhost',:port=>6379)
#$redis = Redis.new(:url=> 'redis://h:pcocr3rgfhgjur136f1sjjtdi4r@ec2-54-83-9-36.compute-1.amazonaws.com:19959')
$redis = Redis.new(:url => ENV["redis://rediscloud:password@localhost:6379"])

while $j < 175 do

	#$redis.set(zip[$j], cdi[$j]+response[$j]+hpcdist[$j]+lat[$j]+long[$j]+suspect[$j]+city[$j]+state[$j]+locid[$j])
	#puts city[$j]
	$redis.hset(zip[$j], $acdi, cdi[$j])
	$redis.hset(zip[$j], $aresponse, response[$j]) 
	$redis.hset(zip[$j], $ahpcdist, hpcdist[$j])
	$redis.hset(zip[$j], $alat, lat[$j])
	$redis.hset(zip[$j], $along, long[$j])
	$redis.hset(zip[$j], $asuspect, suspect[$j])
	$redis.hset(zip[$j], $acity, city[$j])
	$redis.hset(zip[$j], $astate, state[$j])
	$redis.hset(zip[$j], $alocid, locid[$j])

	$j+=1
end

$qzip=0
puts ("Enter the Zip Code [Primary key] for getting the details")
$qzip=gets.chomp
puts "The detais are: "
puts $redis.hget($qzip, $acdi)
puts $redis.hget($qzip, $aresponse)
puts $redis.hget($qzip, $ahpcdist)
puts $redis.hget($qzip, $alat)
puts $redis.hget($qzip, $along)
puts $redis.hget($qzip, $asuspect)
puts $redis.hget($qzip, $acity)
puts $redis.hget($qzip, $astate)
puts $redis.hget($qzip, $alocid)



puts ("Enter the non primary attribute City value")
$npattribute=gets.chomp
$npattribute=" "+'"'+$npattribute+'"'
#puts $npattribute
$l=0
while $l < 175 do
	$val=$redis.hget(zip[$l], $acity)
	# => puts $val
	if ($npattribute==$val)
		puts "\n"
		puts zip[$l]
		puts $redis.hmget(zip[$l],$acdi,$response,$ahpcdist,$alat,$along,$asuspect,$acity,$astate,$alocid)
	end
	$l+=1


end





