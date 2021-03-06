class University < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  has_many :courses
  has_many :elo_scores

  def set_image_url
    puts "https://api.datamarket.azure.com/Bing/Search/v1/Image?$format=json&Query=%27#{CGI.escape(self.title + " campus")}%27"
    data = JSON.parse(open("https://api.datamarket.azure.com/Bing/Search/v1/Image?$format=json&Query=%27#{CGI.escape(self.title + " campus")}%27", :http_basic_authentication=>["8g4bf1KG8MEmBTM1JMnPv47TbemHVjJrhLfG6ZnOFcU", "8g4bf1KG8MEmBTM1JMnPv47TbemHVjJrhLfG6ZnOFcU"]).read)
    url = data["d"]["results"][0]["MediaUrl"]
    x = 1
    while url.length >= 255
      url = data["d"]["results"][x]["MediaUrl"]
      x += 1
    end
    self.save
    self.image_url
  end
end
