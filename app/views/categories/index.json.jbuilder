json.array!(@categories) do |category|
  json.extract! category, :id, :name, :priority, :is_published
  json.url category_url(category, format: :json)
end
