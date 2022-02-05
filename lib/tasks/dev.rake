namespace :dev do
  desc "Configure development environment"
  task setup: :environment do
    if(Rails.env.development?)
      show_spinner ("Cleaning DB...") { %x(rails db:drop) }
      show_spinner ("Creating DB...") { %x(rails db:create) }
      show_spinner ("Migrating DB...") { %x(rails db:migrate) }
      show_spinner ("Add raffles from api...") { %x(rails dev:add_raffles_from_api) }
    else
      puts "You are not in development environment"
    end
  end
  
  desc "Add raffles from api"
  task add_raffles_from_api: :environment do
    quantity = ENV['Q'].to_i - 1 if ENV['Q'] 
    @connection = get_instance
    response_body = get_response_body @connection.get
    raffle = build_raffle response_body
    if raffle
      raffle.save
      if quantity
        build_many_raffles quantity, raffle.contest_number
      else
      end
    end
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

    def get_params contest = nil
        {
            loteria: 'lotofacil',
            token: ENV['API_LOTERIAS_TOKEN'],
            concurso: contest
        }
    end

    def show_spinner msg_start, msg_end = "Success!"
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
      spinner.auto_spin
      yield
      spinner.success "(#{msg_end})"
    end

    def build_raffle response
      unless response["erro"]
        Raffle.new(
          name: response['nome'],
          contest_number: response['numero_concurso'],
          contest_date: response['data_concurso'],
          contest_date_milliseconds: response['data_concurso_milliseconds'],
          place_realization: response['local_realizacao'],
          apportionment_processing: response['rateio_processamento'],
          accumulated: response['acumulou'],
          accumulated_value: response['valor_acumulado'],
          dozens: response['dezenas'].join(','),
          total_collection: response['arrecadacao_total'],
          next_contest: response['concurso_proximo'],
          next_contest_date: response['data_proximo_concurso'],
          next_contest_date_milliseconds: response['data_proximo_concurso_milliseconds'],
          estimated_value_next_contest: response['valor_estimado_proximo_concurso'],
          valor_acumulado_especial: response['valor_acumulado_especial'],
          special_accumulated_value: response['nome_acumulado_especial'],
          special_contest: response['concurso_especial'],
        )
      end
    end

    def build_winner_places raffle, winner_places
      winner_places.map do |place|
        raffle.winner_places.build(
            place: place['place'],
            city: place['cidade'],
            uf: place['uf'],
            winners_quantity: place['quantidade_ganhadores'],
            electronic_channel: place['canal_eletronico'],
        )
      end
      raffle
    end
    
    def build_awards raffle, awards
      awards.map do |award|
        raffle.awards.build(
          name: award['name'],
          winners_quantity: award['quantidade_ganhadores'],
          total_values: award['valor_total'],
          hits: award['acertos']
        )
      end
      raffle
    end
    
    def get_response_body response
      JSON.parse response.body
    end

    def build_many_raffles raffle_quantity = 0, last_contest
      raffle_quantity.times do
        last_contest = last_contest - 1
        response = JSON.parse @connection.get(nil, concurso: last_contest).body
        raffle = build_raffle response
        raffle = build_winner_places raffle, response['local_ganhadores']
        raffle = build_awards raffle, response['premiacao']
        raffle.save
      end
    end

end
