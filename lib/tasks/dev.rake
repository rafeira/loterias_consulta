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
    connection = get_instance
    Raffle.create connection.get.to_json
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
end
