class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :user_ids , type: Array , default: []
  
  belongs_to :invitable, polymorphic: true
  has_many :users
  
end
