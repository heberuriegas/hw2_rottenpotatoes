class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Manejo de parametros
   
    path = {controller: 'movies', action: 'index'}  
    redirect = false
   
    if !params[:sort_title].nil?
      session[:sort_title] = params[:sort_title]
      session[:sort_release_date] = nil
    elsif !params[:sort_release_date].nil?
      session[:sort_title] = nil
      session[:sort_release_date] = params[:sort_release_date]      
    end
    
    
    
    sort_title = session[:sort_title] unless session[:sort_title].nil?
    sort_release_date = session[:sort_release_date] unless session[:sort_release_date].nil?
    
    if params[:ratings].nil? && session[:ratings].nil?
      @ratings = {}
      Movie.get_ratings.sort.each {|t| @ratings[t] = '1'}
      session[:ratings] = @ratings
    else
      session[:ratings] = params[:ratings] unless params[:ratings].nil?
      @ratings = session[:ratings]     
    end
    
    redirect = (session.has_key?(:sort_release_date) && params[:sort_release_date].nil?) && (session.has_key?(:sort_title) && params[:sort_title].nil?)
    redirect = (session.has_key?(:ratings) && params[:ratings].nil?) unless redirect
    
    @session = session
    @redirect = redirect
    
    if redirect
      path[:sort_title] = session[:sort_title] unless session[:sort_title].nil?
      path[:sort_release_date] = session[:sort_release_date] unless session[:sort_release_date].nil?
      path[:ratings] = session[:ratings]
      
      redirect_to path
    end
    
    
    ###############################
    
    if sort_title == '1'
      @movies = Movie.where(rating: @ratings.keys).order("title")
      @sort_title = 1
    elsif sort_release_date == '1'
      @movies = Movie.where(rating: @ratings.keys).order("release_date")
      @sort_release_date = 1
    elsif @ratings.size > 0
      @movies = Movie.where rating: @ratings.keys
    else
      @movies = Movie.all
    end
    
    @all_ratings = Movie.get_ratings.sort
    
    
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
