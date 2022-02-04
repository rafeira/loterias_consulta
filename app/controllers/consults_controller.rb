class ConsultsController < ApplicationController
    def new
        @raffles = Raffle.all
        render 'consults/new'
    end

end