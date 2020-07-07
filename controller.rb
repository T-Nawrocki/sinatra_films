require "sinatra"
require "sinatra/contrib/all"

require_relative "models/film"
also_reload "models/*"

require "pry-byebug"

get "/" do
    @films = Film.all
    @films_display = @films.map { |film| "<a href=\"/#{film.title}\">#{film.title} : £#{film.price}</a>" }
    erb(:index)
end

get "/:title" do
    @film = Film.all.select { |film| film.title == params[:title] }
    erb(:film_details)
end
