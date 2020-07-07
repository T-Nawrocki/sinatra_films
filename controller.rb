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
    film_selected = Film.all.select { |film| film.title == params[:title] }[0]
    @film_title = film_selected.title
    @film_price = film_selected.price
    erb(:film_details)
end
