class MoviesController < ApplicationController

  before_filter :login, :except => [:index, :show, :similar, :search_tmdb]

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
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

  def similar
    @movie = Movie.find params[:id]
    if @movie.director and @movie.director.length > 0
      @movies = Movie.find_all_by_director(@movie.director)
    else
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    end
  end


  def search_tmdb
    @movie_search = Movie.find_in_tmdb(params[:search_terms])

    if @movie_search.class == PatchedOpenStruct
      @movie = Movie.new
      @movie.title = @movie_search.title if @movie_search.respond_to?(:title)
      @movie.rating = @movie_search.rating if @movie_search.respond_to?(:rating)
      @movie.director = @movie_search.crew[0].name rescue @movie.director = nil
      @movie.release_date = @movie_search.release_date if @movie_search.respond_to?(:release_date)
      @movie.description = @movie_search.overview if @movie_search.respond_to?(:overview)
    elsif @movie_search == []
      flash[:notice] = "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path
    end

    rescue Movie::InvalidKeyError
      flash[:warning] = "Search not available."
      redirect_to movies_path
  end

end
