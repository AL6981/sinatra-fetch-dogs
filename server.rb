require 'sinatra'
require 'sinatra/reloader'
require 'pry'

set :bind, '0.0.0.0' 
set :public_colder, File.join(File.dirname(__FILE__), "public")

def dogs
  file = File.read("dogs.json")
  JSON.parse(file)
end

def new_dog_id
  dogs["dogs"].last["id"] + 1
end 

def write_to_json_file(dog)
  new_dog = { id: new_dog_id, breed: dog["breed"] }
  new_dogs = { dogs: dogs["dogs"].concat([new_dog]) }
  json_dogs = JSON.pretty_generate(new_dogs, indent: ' ')
  File.write("dogs.json", json_dogs)
end

get "/dogs" do
  File.read(File.join('public', 'index.html'))
end

get "/api/v1/dogs.json" do 
  content_type :json
  status 200
  dogs.to_json 
end

post "/api/v1/dogs.json" do
  json = JSON.parse(request.body.read)
  if json["dog"]
    write_to_json_file(json["dog"])
    status 200
  else
    status 500
    { error: "Opps, something went wrong!" }.to_json
  end
end