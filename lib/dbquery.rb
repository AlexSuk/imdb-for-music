
#require 'byebug'
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

		# @param {String} type May be "artist", "release-group", "recording"
		# @param {String} string The string to search
		def Musicbrainz_db.search type, string
			path = ""
			if type == "release-group"
				path = type + "/?query=release:" + string
			else
				path = type + "/?query=" + string
			end
			res = Musicbrainz_db.http_req path
			response = JSON::parse res.body
			# FILTER BY SCORE
			arr = []
			response = response["#{type}s"]
			byebug
			response.each do |obj|
				if obj["score"].to_i == 100
					arr << obj
				end
			end
			return arr
		end

		# @param {String} type May be "artist", "release-group", "release", "recording"
		# @param {String} id The MBID of the item to find
		def Musicbrainz_db.find type, id
			path = type + "/" + id
			if type == "artist"
				path += "?inc=release-groups+url-rels+artist-rels"
			elsif type == "release-group"
				path += "?inc=artists+releases"
			elsif type == "release"
				path+= "?inc=recordings"
			elsif type == "recording"
				path += "?inc=artists+releases+release-groups"
			end
			res = Musicbrainz_db.http_req path
			response = JSON::parse res.body
		end

		# @param {String} id The MBID of the release-group whose cover art to find
		def Musicbrainz_db.get_cover_art id
			url = "http://coverartarchive.org/release-group/" + id
			uri = URI.parse(url)
			req = Net::HTTP::Get.new(uri)
			res = Net::HTTP.start(uri.hostname, uri.port) {|http|
				http.request(req)
			}
			if res.code == "307" #redirect
				uri = URI.parse(res.body.split(" ")[1])
				JSON::parse(uri.read)
			else
				res.body
			end
		end

end
