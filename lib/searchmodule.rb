require 'dbquery'
require 'melocache'
module SearchModule

	def SearchModule.search type, string
		if MeloCache.exists type+string
			query = MeloCache.get type+string
			return eval(query)
		else
			query = Musicbrainz_db.search(type, string)
			MeloCache.set type+string, query.to_s
			return query
		end
	end

	def SearchModule.find type, id	
		if MeloCache.exists type+id
			query = MeloCache.get type+id
			return eval(query)
		else
			query = Musicbrainz_db.find(type, id)
			MeloCache.set type+id, query.to_s
			return query
		end
	end

	def SearchModule.exists_cover_art id
		MeloCache.exists "cover_art"+id
	end

	def SearchModule.set_cover_art id, imgurls
		MeloCache.set "cover_art"+id, imgurls.to_s
	end

	def SearchModule.get_cover_art id
		if MeloCache.exists "cover_art"+id
			imgurls = MeloCache.get "cover_art"+id
			return eval(imgurls)
		else
			query = Musicbrainz_db.get_cover_art id
			SearchModule.set_cover_art id, query
			return query
		end
	end
end