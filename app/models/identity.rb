class Identity
  include Mongoid::Document
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  field :provider, type: String
  field :uid, type: String
  #embedded_in :user



  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
