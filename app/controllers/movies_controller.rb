class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    @ratings = @all_ratings

    if params[:ratings]
      @ratings = []
      params[:ratings].each_key { 
        |k|
        @ratings << k
      }
    end

    if @ratings.length > 0
      @movies = Movie.with_ratings(@ratings)
    end

    if @movies
      @movies = @movies.all
    else
      @movies = Movie.all
    end

    @sort_title = params[:sort_title]
    if @sort_title == 'true'
      @movies = @movies.order(:title)
    end

    @sort_release_date = params[:sort_release_date]
    if @sort_release_date == 'true'
      @movies = @movies.order(:release_date)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
