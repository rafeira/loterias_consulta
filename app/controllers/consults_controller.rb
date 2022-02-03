class ConsultsController < ApplicationController
    def new
        @response = JSON.parse(get_instance.get.body)
        puts @response
        puts ENV['API_LOTERIAS_TOKEN']
        @raffle = Raffle.new(
            name: @response['nome'],
            contest_number: @response['numero_concurso'],
            contest_date: @response['data_concurso'],
            contest_date_milliseconds: @response['data_concurso_milliseconds'],
            place_realization: @response['local_realizacao'],
            apportionment_processing: @response['rateio_processamento'],
            accumulated: @response['acumulou'],
            accumulated_value: @response['valor_acumulado'],
            dozens: @response['dezenas'],
            total_collection: @response['arrecadacao_total'],
            next_contest: @response['concurso_proximo'],
            next_contest_date: @response['data_proximo_concurso'],
            next_contest_date_milliseconds: @response['data_proximo_concurso_milliseconds'],
            estimated_value_next_contest: @response['valor_estimado_proximo_concurso'],
            valor_acumulado_especial: @response['valor_acumulado_especial'],
            special_accumulated_value: @response['nome_acumulado_especial'],
            special_contest: @response['concurso_especial'],
        )
        @raffle.save
        #render 'consults/new'
    end
    private
        def get_instance params = get_params, headers = get_headers
            Faraday.new(
                url: "https://apiloterias.com.br/app/resultado",
                params: params,
                headers: get_headers
            )
        end
        def get_headers
            {
                'Content-Type' => 'application/json',
            }
        end
        def get_params
            {
                loteria: 'lotofacil',
                token: ENV['API_LOTERIAS_TOKEN'],
                concurso: nil
            }
        end

end