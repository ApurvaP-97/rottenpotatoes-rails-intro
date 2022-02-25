class Movie < ActiveRecord::Base
  def self.with_ratings(ratings)
    return Movie.all unless ratings
    ratings = ratings.map { |rating| rating.upcase }
    Movie.where(rating: ratings)
  end

  def self.all_ratings
    Movie.select(:rating).uniq.map do |record|
      record.rating
    end
  end
end
