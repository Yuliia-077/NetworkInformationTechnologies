require 'open-uri'
require 'nokogiri'
require 'csv'

url = "https://shahmaty.info/top-fide/"
html = URI.open(url){ |result| result.read }

document = Nokogiri::HTML(html)
players = []
players = document.css('.table-content-list > div').map do |tr_node|
    {
        title: tr_node.at('.col_r_2').text,
        name: tr_node.at('.col_r_3').text.gsub(/^[" "]/,''),
        classic: tr_node.at('.col_r_5').text.gsub(/["\n "]/,''),
        rapid: tr_node.at('.col_r_6').text.gsub(/["\n "]/,''),
        blitz: tr_node.at('.col_r_7').text.gsub(/["\n "]/,''),
        age: tr_node.at('.col_r_8').text
    }
end
headers = []
headers = ["Title", "Name", "Classic", "Rappid", "Blitz", "Age"]

CSV.open('ratings.csv', 'w') do |csv|
    csv << headers
    players.each { |player| csv << player.values }
end