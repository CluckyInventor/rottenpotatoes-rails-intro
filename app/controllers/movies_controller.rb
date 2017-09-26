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
    #it may not be the best solution, but I thought to feed the array given to the checkboxes both the name and if it is chosen.
    #rating_choices is what I assign that to. Rating_selections is just the array of checked ratings for the filtering code.
    unless params[:ratings]
      @rating_choices = [{name:"G", chosen: true}, {name: "PG", chosen: true}, {name: "PG-13", chosen: true},{name: "R", chosen: true}]
      rating_selections = ["G", "PG", "PG-13", "R"]
    else
      rating_selections = params[:ratings].keys
      @rating_choices = [{name:"G", chosen: false}, {name: "PG", chosen: false}, {name: "PG-13", chosen: false},{name: "R", chosen: false}]
      rating_selections.each do |rating|
        @rating_choices[@rating_choices.index() {|item| item[:name] == rating }] = {name: rating, chosen: true}
      end
    end
    #Not sure why the following line isn't working, so I'm just gonna hard code it :(
    # @all_ratings = Movie.all_ratings
    # @all_ratings = ["G","PG","PG-13","R"]
    #Using unless is probably backwards here, but I felt like putting the default case first
    unless params[:sorting] == "Date"
      #@movies = Movie.all.sort {|mov, other| mov.title <=> other.title}
      @movies = Movie.where({rating: rating_selections}).reorder('title')
      @titleClass = "hilite"
      @dateClass = ""
    else
      #@movies = Movie.all.sort {|mov, other| mov.release_date <=> other.release_date}
      @movies = Movie.where({rating: rating_selections}).reorder('release_date')
      @titleClass = ""
      @dateClass = "hilite"
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
