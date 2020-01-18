class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::MultiParameterAttributes
  include Geocoder::Model::Mongoid

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  field :name, type:  String
  field :picture, type: String
  field :description, type:  String
  field :start_time, type:  DateTime
  field :end_time, type:  DateTime
  field :privacy, type:  String
  field :attendees_count, type: Integer, default: 0
  field :address, type: String
  field :coordinates, type: Array

  mount_uploader :picture, PictureUploader

  validates_presence_of :name, :description, :start_time, :end_time
  validate :start_time_cannot_be_in_the_past, :end_time_greater_than_start_time
  paginates_per 8

  belongs_to :group
  #index :group_id
  accepts_nested_attributes_for :group
  #embeds_one :location, as: :locatable
  #accepts_nested_attributes_for :location

  belongs_to :creator, class_name: "User", inverse_of: :created_events

  has_one :invited, as: :invitable , class_name: "Invitation"
  accepts_nested_attributes_for :invited

  has_and_belongs_to_many :attendees, class_name: "User", inverse_of: :attending_events

  after_initialize :initialize_fields

  def add_attendee(user)
    if !attendee?(user)
      self.push( attendee_ids: user.id)
      self.inc( attendees_count: 1)
      user.push( attending_ids: self.id )
    end
  end

  def remove_attendee(user)
    if attendee?(user)
      self.pull( attendee_ids: user.id)
      self.inc( attendees_count: -1)
      user.pull( attending_ids: self.id )
      #TODO remove event from attending_ids in user
      #self.user.update_reputation(:event_undo_follow, self.group)
    end
  end

  def attendee?(user)
    self.attendee_ids && self.attendee_ids.include?(user.id)
  end

  #  def creator(user)
  #    self.user = user
  #  end

  def initialize_fields
    if self.address.nil?
      if self.group? && self.group.address?
        self.address = self.group.address
      end
    end
  end

  #users = array of user ids
  def invite(users = [])
    if self.invited.nil?
      self.invited = Invitation.new
    end

    if !users.empty?
      self.invited.users = users
    end

  end

  def start_time_cannot_be_in_the_past
    if start_time.present? && start_time < Time.now
      errors.add(:start_time, I18n.t(:start_time_past, default: "can't be in the past"))
    end
  end

  def end_time_greater_than_start_time
    if end_time.present? && end_time < start_time
      errors.add(:end_time, I18n.t(:end_time_past, default: "can't be before start time"))
    end
  end

  @today_range = Date.tomorrow.to_time + 6.hours
  @week_range = Time.now + 1.week
  @month_range = Time.now + 1.month

  default_scope -> {order_by(:start_time => :asc)}

  scope :today , lambda { where(:end_time.gte => Time.now).where(:start_time.lte => @today_range)  }
  scope :this_week ,  lambda { where(:end_time.gte => Time.now).where(:start_time.lte => @week_range) }
  scope :this_month,  lambda { where(:end_time.gte => Time.now).where(:start_time.lte => @month_range) }
  scope :future, -> { where(:end_time.gte => Time.now) }
  scope :past, -> { where(:end_time.lte => Time.now).order_by(:start_time => :desc)}

end
