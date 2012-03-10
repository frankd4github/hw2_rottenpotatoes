class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    if params.has_key?('sort')
      @sort = session['sort'] = params['sort']
    else
      @sort = params['sort'] = session['sort']
      redirect = true
    end
    @class_title_header = 'hilite' if @sort=='title'
    @class_release_date_header = 'hilite' if @sort=='release_date'
    if params.has_key?('ratings')
      @ratings = session['ratings'] = params['ratings']
    elsif session.has_key?('ratings')
      @ratings = params['ratings'] = session['ratings']
      redirect = true
    else
      @ratings = Hash.new
      @all_ratings.each {|elt| @ratings[elt] = 1}
      session['ratings'] = params['ratings'] = @ratings
      redirect = false
    end
    if redirect
      ratings_in_path = @ratings.keys.map {|rating| "ratings[#{rating}]=1"}.join('&')
      redirect_to "/movies?sort=#{@sort}&#{ratings_in_path}"
      #redirect_to movies_path #('sort' => @sort, 'ratings' => @ratings)
      #redirect_to movies_path #"/movies?sort=#{@sort}"
      # redirect_to "/movies?sort=#{@sort}&ratings[PG]=1"
    end
    @movies = Movie.find_all_by_rating(@ratings.keys, :order => @sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
