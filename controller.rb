require "sinatra"
require "sinatra/contrib/all"

require_relative "models/film"
also_reload "models/*"

get "/" do
    @films = Film.all
    erb(:index)
end
