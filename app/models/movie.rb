class Movie < ActiveRecord::Base
    def self.sort_by_title
        Movie.all.order("title")
    end

    def self.sort_by_release_date()
        Movie.all.order("release_date")
    end 

end
