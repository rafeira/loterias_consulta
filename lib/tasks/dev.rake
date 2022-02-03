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
    def get_params
        {
            loteria: 'lotofacil',
            token: ENV['API_LOTERIAS_TOKEN'],
            concurso: nil
        }
    end
end
