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
    @checked_ratings = session_ratings
    
    session_reset

    
    if @sort_items
      @movies = Movie.with_ratings(@checked_ratings).order(@sort_items)
    else
      @movies = Movie.with_ratings(@checked_ratings)
    end
    
    @title_header = session[:sort] == 'title'? 'bg-warning': nil
    @release_date_header = session[:sort] == 'release_date'? 'bg-warning': nil
    
    
    
  end
    
  private
  def session_ratings
    if params[:ratings] != nil and params[:ratings] != session[:ratings]
        session[:ratings] = params[:ratings]
    end
    return @all_ratings if session[:ratings].nil?
    return session[:ratings] if session[:ratings].is_a?(Array)
    session[:ratings].keys
  end
  
  def session_items
    return session[:sort_items] if params[:sort].nil?
    session[:sort_items] = params[:sort]
  end

  def session_reset
      if (session[:sort] != params[:sort]) or (session[:ratings] != params[:ratings])
        flash.keep
        redirect_to({:sort => session[:sort], :ratings => session[:ratings]})
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
