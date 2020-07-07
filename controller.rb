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
    @film_screenings = film_selected.screenings.empty? ? "None" : film_selected.screenings.map { |screening| screening.time }.join(", ")
    @film_customers = film_selected.customers.empty? ? "None" : film_selected.customers.map { |customer| customer.name }.join(", ")
    
    erb(:film_details)
end
