require 'spec_helper'

describe Movie do

  describe 'Models' do
    it 'Should return a list of ratings' do
      r = Movie.all_ratings
      r.length.should == 5
    end
  end

  describe 'searching Tmdb by keyword' do
    it 'should call Tmdb with title keywords' do
      TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception')
      Movie.find_in_tmdb('Inception')
    end
    it 'should raise an InvalidKeyError with no API key' do
      Movie.stub(:api_key).and_return('')
      lambda { Movie.find_in_tmdb('Inception') }.should raise_error(Movie::InvalidKeyError)
    end
    it 'should raise an InvalidKeyError with invalid API key' do
      TmdbMovie.stub(:find).and_raise(RuntimeError.new("API returned status code '404'"))
      Movie.stub(:api_key).and_return('INVALID')
      lambda { Movie.find_in_tmdb('Inception') }.should raise_error(Movie::InvalidKeyError)
    end
  end
end

