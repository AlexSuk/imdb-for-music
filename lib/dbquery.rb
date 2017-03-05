require 'byebug'
require 'uri'
require 'net/http'
require 'json'
	
	module  Musicbrainz_db
		def self.http_req path
			url = "http://musicbrainz.org/ws/2/"+path+"&fmt=json"
			uri = URI.parse(url)
			req = Net::HTTP::Get.new(uri)
			#req['User-Agent'] = "Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion"
			req['User-Agent'] = "Brandeis University - Cosi166 Capstone Project"
			res = Net::HTTP.start(uri.hostname, uri.port) {|http|
			  http.request(req)
			}
			res
		end
		def Musicbrainz_db.search artist, album, track
			#specify up to 2 criteria. For some reason if 3 are specified, the last one is not searched
			#option 0 = artist only
			#option 1 = album only
			#option 3 = artist and album
			path=""
			if(!artist.nil?)
				path += "=artist=" + artist
			end
			if(!album.nil?)
				path += "=album=" + album
			end
			if(!track.nil?)
				path += "=recording=" + track
			end
			path = "release/?query" + path
			res = Musicbrainz_db.http_req path
			response = JSON::parse res.body
		end
		def Musicbrainz_db.find_with_id option, id
			#option 0 = release group
			#option 1 = artist
			#option 2 = release 
			if(option==0)
				path="release-group/" + id +"?inc=artist-credits+releases"
			elsif(option==1)
				path = "artist/"+ id + "?inc=aliases"
			elsif(option==2)
				path= "release/"+id+"?inc=artist-credits"
			end
			res = Musicbrainz_db.http_req path
			response = JSON::parse res.body
		end
	end
  
=begin
usage examples:
Musicbrainz_db.search  "Metallica", nil, "fuel"
Musicbrainz_db.find_with_id 2, "363f1d27-87c3-3236-94f4-517a7e678e36"
=end
