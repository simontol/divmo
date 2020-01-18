class FriendList
  include Mongoid::Document
  
  #identity :type => String
  
  has_one :user
  
  has_and_belongs_to_many :followers, :class_name => "User", :inverse_class_name => "User"
  
  has_and_belongs_to_many :following, :class_name => "User", :inverse_class_name => "User"

end
