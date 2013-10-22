class ScraperController < ApplicationController

	def octafx

		require 'rubygems'
		require 'hpricot'
		require 'open-uri'


		doc = open("http://www.octafx.com/contests/octafx-champion/9/member/hedongming") {
			|f|
			Hpricot(f)
		}

		response = []
		(doc/"#tid1 tbody tr").each do |tr|
			
			rec = (tr/ "td").map { |tdcontent| tdcontent.inner_html.gsub("<br />"," ") }
			response << rec

		end

		render :text => response.to_json()


	end
end
