class Movie < ActiveRecord::Base
  
  def self.get_ratings
    movies = self.all
    ratings = []
    
    movies.each do |t|
      ratings.push t.rating unless ratings.include? t.rating
    end
    
    ratings   
  end
end
