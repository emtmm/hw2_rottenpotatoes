class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sorting_params = params[:sort] 
    sorting_rating_params = params[:ratings]
    if sorting_params == nil
      sort_order = nil
    elsif sorting_params == 'title'
      sort_order, @sort_title = {:order => :title}, 'hilite'
    else
      sort_order, @sort_release = {:order => :release_date}, 'hilite'
    end

    @all_ratings = Movie.all_ratings
    @checked_ratings = params[:ratings] || session[:ratings] || {}

    if @checked_ratings == {}
      @checked_ratings = Hash[@all_ratings.map { |rating| [rating, rating]  }]
    end

    if params[:ratings] != session[:ratings]
      session[:ratings] = @checked_ratings
      redirect_to :sort => sort_order, :ratings => @checked_ratings
    end

    @movies = Movie.find_all_by_rating(@checked_ratings.keys, sort_order)
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
