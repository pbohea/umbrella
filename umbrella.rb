# Write your soltuion here!
require "http"
require "dotenv/load"
require "json"
pp "Hi! Where are you located?"

user_loc = gets.chomp
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_loc}&key=#{ENV.fetch("GMAPS_KEY")}"
#pp gmaps_url
raw_response_gmaps = HTTP.get(gmaps_url)
#pp raw_response_gmaps

parsed_response_gmaps = JSON.parse(raw_response_gmaps)

#pp parsed_response_gmaps
results = parsed_response_gmaps.fetch("results")

address_components = results.at(0)
geometry = address_components.fetch("geometry")

#pp "break"
location = geometry.fetch("location")
#pp location
lat = location.fetch("lat")
lng = location.fetch("lng")
#pp lat
#pp lng

pirate_weather_url = "https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_KEY")}/#{lat},#{lng}"
#pp pirate_weather_url
raw_response_pirate = HTTP.get(pirate_weather_url)
parsed_response_pirate = JSON.parse(raw_response_pirate)

temp = parsed_response_pirate.fetch("currently").fetch("temperature")
#pp temp

hourly = parsed_response_pirate.fetch("hourly")

summary_next_hour = hourly.fetch("summary")

#pp summary_next_hour

pp "The current temperature is #{temp} and the weather for the next hour is projected to be #{summary_next_hour.downcase}"



hourly_data = hourly.fetch("data")

#now inside the data array. need to get each of the next 12. 
#pp hourly_data

# for i in (0..11)

rain = false

12.times do |i|
  inside = hourly_data.at(i)
  precip_odds = inside.fetch("precipProbability")

  if precip_odds > 0.1
    rain = true
  end
end

pp rain

if rain == true
  pp "You might want to carry an umbrella!"
else 
  pp "You probably won't need an umbrella today."
end
