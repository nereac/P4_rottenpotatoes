
require 'spec_helper'

describe MoviesController do
    
  fixtures :movies
  before :each do
    @fake_movie = movies(:star_wars_movie)
  end

  describe "show" do
    it "assigns the requested movie as @movie" do
      Movie.stub!(:find).with("1").and_return(@fake_movie)
      get :show, :id => "1"
      assigns[:movie].should == @fake_movie
      response.should render_template("show")
    end
  end

  describe "index" do
     it "call model method find_all_by_rating, assigns all movies as @movies" do
      Movie.should_receive(:find_all_by_rating).and_return(@fake_movie)
      get :index
      assigns[:movies].should == @fake_movie
    end
    it "should sort by 'title' when :sort is 'title'" do
      get :index, :sort => 'title'
      assigns[:title_header].should == 'hilite'
    end
    it "should sort by 'release_date' when :sort is 'release_date'" do
      get :index, :sort => 'release_date'
      assigns[:date_header].should == 'hilite'
    end
   it "should filter movies" do
      get :index, :ratings => 'G'
      assigns[:selected_ratings].should == 'G'
    end
  end

  describe "new" do
    it "it should  select the new movie template for rendering" do
      get :new
      response.should render_template('new')
    end
  end

  describe "create" do
    it 'should call the model method performe create!' do
      Movie.should_receive(:create!).with({'title' => "star_wars"}).and_return(@fake_movie)
      post :create, :movie => {:title => "star_wars"}
    end
    it 'should redirected to movies path after create new object' do
      post :create, :movie => {:title => "star_wars"}
      response.should redirect_to movies_path
    end
  end

  describe "edit" do
    it "assigns the requested movie as @movie" do
      Movie.stub!(:find).with("1").and_return(@fake_movie)
      get :edit, :id => "1"
      assigns[:movie].should == @fake_movie
      response.should render_template("edit")
    end
  end

  describe "update" do
    it "update the requested movie" do
      Movie.should_receive(:find).with("1").and_return(@fake_movie)
      @fake_movie.should_receive(:update_attributes!)
      put :update, :id => @fake_movie.id, :movie => @fake_movie.attributes
      assigns(:movie).should == @fake_movie
      response.should redirect_to movie_path(:id => @fake_movie.id)
    end
  end

  describe 'destroy' do
    it "destroys the requested movie" do
      Movie.should_receive(:find).with("1").and_return(@fake_movie)
      @fake_movie.should_receive(:destroy).and_return(true)
      delete :destroy, :id => @fake_movie.id
      response.should redirect_to(movies_path)
    end
  end


  describe 'searching for Similar Movies' do
    before :each do
      @fake_movie_similar = [movies(:star_wars_movie), movies(:thx_1138_movie)]
    end
    it 'should find the similar movies by director' do
      Movie.should_receive(:find).with('1').and_return(@fake_movie)
      Movie.should_receive(:find_all_by_director).with(@fake_movie.director).and_return(@fake_movie_similar)
      get :similar, {:id => '1'}
    end
    describe 'after valid search' do
      it 'should select the Similiar Movies template for rendering' do
        get :similar, {:id => '1'}
        response.should render_template('similar')
      end
      it 'it should make the results available to the template' do
        get :similar, {:id => '1'}
        assigns(:movies).should == @fake_movie_similar
      end
    end
    it 'should redirect to home page when director is empty' do
      @fake_movie = movies(:alien_movie) 
      Movie.should_receive(:find).with('3').and_return(@fake_movie)
      get :similar, {:id => @fake_movie.id}
      response.should redirect_to movies_path
    end
  end



  describe 'searching TMDb' do
    before :each do
      @fake_results = PatchedOpenStruct.new
    end
    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end

    describe 'After valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movie_search).should == @fake_results
      end
    end

    describe 'After a invalid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return([])
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should redirect to index' do
        response.should redirect_to movies_path
      end
      it 'should see a message for search results' do
        flash[:notice].should == "'hardware' was not found in TMDb."
      end
    end

    describe 'When there is no API key' do
      before :each do
        Movie.stub(:api_key).and_return('')
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should raise an InvalidKeyError with no API key' do
        response.should redirect_to movies_path
      end
      it 'should see a message for search results' do
        flash[:warning].should == "Search not available."
      end
    end
    
    describe 'When API key is invalid' do
      before :each do
        TmdbMovie.stub(:find).and_raise(RuntimeError.new("API returned status code '404'"))
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should raise an InvalidKeyError with no API key' do
        response.should redirect_to movies_path
      end
      it 'should see a message for search results' do
        flash[:warning].should == "Search not available."
      end
    end
  end

end



