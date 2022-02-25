class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @sort_items = session_items
    @checked_ratings = check
    session_reset
    @checked_ratings.each do |rating|
      params[rating] = true
    end
    
    if @sort_items
      @movies = Movie.with_ratings(@checked_ratings).order(@sort_items)
    else
      @movies = Movie.with_ratings(@checked_ratings)
    end
  end
    
  private
  def check
    return session[:checked_ratings] if params[:ratings].nil?
    return session[:checked_ratings]=params[:ratings] if params[:ratings].is_a?(Array)
    session[:checked_ratings] = params[:ratings].keys
  end
  
  def session_items
    return session[:sort_items] if params[:sort].nil?
    session[:sort_items] = params[:sort]
  end

  def session_reset
    session[:sort_items] = @sort_items
    session[:ratings] = @checked_ratings
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
