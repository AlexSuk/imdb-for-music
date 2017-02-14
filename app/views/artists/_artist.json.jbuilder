json.extract! artist, :id, :name, :group_type, :image_url, :country, :date_started, :date_ended, :created_at, :updated_at
json.url artist_url(artist, format: :json)