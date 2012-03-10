class Movie < ActiveRecord::Base
  def Movie.all_ratings
    #Movie.find_by_sql("select distinct rating from movies").map {|movie_rating| movie_rating.rating}
    Movie.all.each.map {|movie| movie.rating}.uniq.sort
  end
end
