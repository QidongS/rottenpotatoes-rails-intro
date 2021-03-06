class MoviesController < ApplicationController

def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected = :None
    @all_ratings = Movie.all_ratings

    if (!params[:ratings] && session[:ratings]) || (!params[:sort] && session[:sort])
      redirect_to movies_path(ratings: params[:ratings]||session[:ratings], sort: params[:sort]||session[:sort])
    end 

    if params[:ratings] && params[:ratings].length>0
      @checked_ratings = params[:ratings]
      session[:ratings] = @checked_ratings
    elsif session[:ratings]
      @checked_ratings = session[:ratings]
    else 
      @checked_ratings = @all_ratings
    end

    @checked_ratings = @checked_ratings.keys if @checked_ratings.class != Array
    @movies = Movie.with_ratings(@checked_ratings)
     
    
    if params[:sort]
      @sort = params[:sort] 
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
    end 

    if !@sort.nil?
      if( @sort == "title")
        @movies = @movies.order("title")
        @selected = :title
      elsif (@sort == "release_date")
        @movies = @movies.order("release_date")
        @selected = :release_date
      end
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
