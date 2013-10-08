json.array!(@zones) do |zone|
  json.extract! zone, 
  json.url zone_url(zone, format: :json)
end
