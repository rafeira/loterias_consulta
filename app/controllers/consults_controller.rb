class ConsultsController < ApplicationController
	before_action :set_input_values, only: [:search]
	def search
		@errors = []
		set_errors if params["0"]
		@raffles = []
		if @errors.empty?
			@raffles = Raffle.all
		end

		render 'consults/search'
	end
	private
		def numbers_params
			params.permit("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15")
		end
		def set_input_values
			@values = numbers_params.values
		end

		def set_errors
			if numbers_params.values.any?{|v| v.empty?}
				@errors << "Todos os campos devem ser preenchidos!"
			elsif numbers_params.values.to_set.length < 15
				@errors << "Os valores não podem ser repetidos!"
			end
			if numbers_params.values.any?{|v| v.to_i <= 0 || v.to_i > 25}
				@errors << "Insira valores válidos!"
			end
		end
end