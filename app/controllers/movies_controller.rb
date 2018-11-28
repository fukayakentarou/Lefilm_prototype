class MoviesController < ApplicationController
  before_action :require_user_logged_in
  
  def show
    @movie = Movie.find(params[:id])
    @like_users = @movie.users
    @review = current_user.reviews.build  # form_for 用
    @reviews = current_user.reviews.order('created_at DESC').page(params[:page])
    
  end
  
  
  def new
    @movies = []
    @keyword = params[:keyword]
    if params[:keyword]
      @search = Tmdb::Search.new
      @search.resource('movie')
      @search.query(@keyword)
      @search.fetch
      results = @search.fetch.first(20)
      
      
      results.each do |result|
        movie = Movie.find_or_initialize_by(read(result))
        @movies << movie
      end
    end
  end
end
