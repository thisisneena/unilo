class University < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  has_many :courses
  has_many :elo_scores

  def photo_url
    data = JSON.parse(open("https://api.datamarket.azure.com/Bing/Search/v1/Image?$format=json&Query=%27#{URI.encode(self.title.gsub('&', '\&') + " campus")}%27", :http_basic_authentication=>["8g4bf1KG8MEmBTM1JMnPv47TbemHVjJrhLfG6ZnOFcU", "8g4bf1KG8MEmBTM1JMnPv47TbemHVjJrhLfG6ZnOFcU"]).read)
    image_url = data["d"]["results"][0]["MediaUrl"]
  end
end