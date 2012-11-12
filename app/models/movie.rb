class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError ; end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.api_key
    '306cc95d422ef943fa82b8a863cf6d6b' # pon aquí tu API key de Tmdb
  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string, :limit => 1)
    rescue ArgumentError => tmdb_error
      raise Movie::InvalidKeyError, tmdb_error.message
    rescue RuntimeError => tmdb_error
      if tmdb_error.message =~ /status code '404'/
        raise Movie::InvalidKeyError, tmdb_error.message
      else
        raise RuntimeError, tmdb_error.message
      end
    end
  end

end
