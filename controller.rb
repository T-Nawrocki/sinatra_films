require "sinatra"
require "sinatra/contrib/all"

require_relative "models/film"
also_reload "models/*"

get "/" do
    films = Film.all
    @films_display = films.map { |film| "#{film.title} : £#{film.price}" }
    erb(:index)
end
