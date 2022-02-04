class Raffle < ApplicationRecord
    has_many :winner_places
    has_many :awards
end
