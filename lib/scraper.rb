require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    hashs = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
     profile = student.css("a")[0].attributes["href"].value
     name = student.css("h4")[0].children[0]
     location = student.css("p")[0].children[0]
     hashs << {:name => "#{name}", :location => "#{location}", :profile_url => "#{profile}"} 
    end
    hashs
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    doc = Nokogiri::HTML(open(profile_url)) 
    doc.css("div.social-icon-container a").collect do |icon|
      if icon["href"].include?("twitter")
        hash[:twitter] = icon["href"]
      elsif icon["href"].include?("linkedin")
       hash[:linkedin] = icon["href"]
      elsif icon["href"].include?("github")
       hash[:github] = icon["href"]
     else
       hash[:blog] = icon["href"]
    end
  end
   hash[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")
   hash[:bio] = doc.css("div.description-holder p").text if doc.css("div.description-holder p")
   hash 
  end
  
end

