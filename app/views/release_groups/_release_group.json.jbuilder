json.extract! release_group, :id, :name, :record_label, :image_url, :created_at, :updated_at
json.url release_group_url(release_group, format: :json)