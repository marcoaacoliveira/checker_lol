load './config.rb'
require 'rest-client'

class Checker
  attr_reader :api_key
  def initialize(api_key=API_KEY)
    @api_key = api_key
  end

  def get_id(name)
    begin
    	summoner = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.4/summoner/by-name/#{name}?api_key=#{@api_key}"
    rescue => e
    	return e.http_code
    end
    summoner = JSON.parse(summoner)
    summoner[name.downcase]['id']
  end

  def get_ranked(summoner)
  	id = to_id(summoner)
    begin
    	ranked = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.3/stats/by-summoner/#{id}/ranked?season=SEASON2015&api_key=#{@api_key}"
    rescue => e
    	return e.http_code
    end
    JSON.parse(ranked)
  end

  def get_champion_by_id(id)
  	begin
	  	champions = RestClient.get "https://global.api.pvp.net/api/lol/static-data/br/v1.2/champion?champData=all&api_key=#{@api_key}"
  	rescue => e
  		return e.http_code
  	end
  	champions = JSON.parse(champions)
  	champions["keys"][id.to_s]
  end
	
	def total_ranked(summoner)
    response = get_ranked(summoner)
    if(response.class == Hash)
	    total = response['champions'].last
	    total['stats']
		else
			"Summoner não encontrado"
		end
	end

  def ranked_status_by_champion(summoner, champion)
  	response = get_ranked(summoner)
  	if(response.class == Hash)
		  total = response["champions"]
	  	arr = total.select do |x|
	  		x["id"] == champion.to_i
	  	end
	  	if(arr!=[])
		  	return arr[0]["stats"]
			else
				return "Champion não encontrado"
			end
	  else
	  	"Summoner não encontrado"
	  end
  end

  private
  #Converte um summoner para ID (passando o proprio ID ou um nome de invocador)
  def to_id(summoner)
  	summoner = summoner.to_s
    summoner=~/[0-9]{2,8}/ ? summoner.to_i : get_id(summoner)
  end
end