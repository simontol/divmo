class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  field :name, type: String
  field :picture, type: String
  field :description, type: String
  field :type, type: String, default: "USERGROUP"
  field :category, type: String
  field :privacy, type: String, default: "OPEN"
  field :website, type: String
  field :link, type: String
  field :likes, type: Integer, default: 0
  field :checkins, type: Integer, default: 0
  field :owner_id, type: String
  field :status, type: String, default: "active"
  field :address, type: String
  field :coordinates, type: Array

  paginates_per 8
  mount_uploader :picture, PictureUploader


  #embeds_one :location , as: :locatable
  #accepts_nested_attributes_for :location
  belongs_to :owner , class_name: "User", inverse_of: :owned_groups
  #index :user_id
  has_many :events, :dependent => :destroy, :validate => false
  has_many :membership, :dependent => :destroy , :validate => false

  after_initialize :initialize_fields

  validates_presence_of     :owner
  validates_presence_of     :name


  def is_member?(user)
    user.member_of?(self)
  end

  def add_member(user, role)
    user.join!(self) do |membership|
      membership.role = role
    end
  end

  def members
    self.membership.all
  end

  def owners
    self.memberships.where(:role => 'owner')
  end

  def mods
    self.memberships.where(:role => 'moderator')
  end


  def initialize_fields
    # self.location = Location.new if self.location.nil?
  end

  #TODO: active = true
  default_scope ->{order_by(:created_at => :asc)}
end
