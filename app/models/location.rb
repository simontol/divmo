class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid

	geocoded_by :address, :skip_index => true
	after_validation :geocode, :if => :address_changed?	

  field :address, type: String
	field :coordinates, type: Array
  
  embedded_in :locatable, polymorphic: true
  
end
