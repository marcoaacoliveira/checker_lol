load './config.rb'
require 'rest-client'

class Checker
  attr_reader :api_key
  def initialize(api_key=API_KEY)
    @api_key = api_key
  end

  def get_id(name)
    summoner = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.4/summoner/by-name/#{name}?api_key=#{@api_key}"
    summoner = JSON.parse(summoner)
    summoner[name.downcase]['id']
  end

  def get_ranked(summoner)
  	id = to_id(summoner)
    ranked = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.3/stats/by-summoner/#{id}/ranked?season=SEASON2015&api_key=#{@api_key}"
    JSON.parse(ranked)
  end

  def get_champion_by_id(id)
  	champions = RestClient.get "https://global.api.pvp.net/api/lol/static-data/br/v1.2/champion?champData=all&api_key=#{@api_key}"
  	champions = JSON.parse(champions)
  	champions["keys"][id.to_s]
  end
	
	def total_ranked(summoner)
    total = get_ranked(summoner)['champions'].last
    total['stats']
	end

  def ranked_status_by_champion(summoner, champion)
  	total = get_ranked(summoner)["champions"]
  	arr = total.select do |x|
  		x["id"] == champion.to_i
  	end
  	arr[0]["stats"]
  end

  private
  #Converte um summoner para ID (passando o proprio ID ou um nome de invocador)
  def to_id(summoner)
  	summoner = summoner.to_s
    summoner=~/[0-9]{2,8}/ ? summoner.to_i : get_id(summoner)
  end
end