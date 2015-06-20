require 'rest-client'
class Checker
  attr_reader :api_key
  def initialize(api_key)
    @api_key = api_key
  end

  def get_id(name)
    summoner = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.4/summoner/by-name/#{name}?api_key=#{@api_key}"
    summoner = JSON.parse(summoner)
    summoner[name.downcase]['id']
  end

  def get_ranked(info)
    info = info.to_s
    id = info=~/[0-9]{2,8}/ ? info : get_id(info)
    ranked = RestClient.get "https://br.api.pvp.net/api/lol/br/v1.3/stats/by-summoner/#{id}/ranked?season=SEASON2015&api_key=#{@api_key}"
    JSON.parse(ranked)
  end

  def total_ranked(info)
    total = get_ranked(info)['champions'].last
    total['stats']
  end

end