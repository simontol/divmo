class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w[user moderator admin]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_presence_of :email, :encrypted_password
  validates_uniqueness_of :email, :case_sensitive => false

  #attr_accessible :username, :email, :password, :password_confirmation, :picture, :remember_me, :first_name, :last_name, :role, :gender, :interests, :birthday, :hometown, :bio, :website
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  field :name
  field :username
  field :gender
  field :locale, type: String, default: "it_IT"
  field :timezone, type: String, default: "UTC+1"
  field :role,    type: String, default: "user"
  field :picture, type: String
  field :privacy
  field :accepts_terms_and_conditions, type: Boolean

  field :bio
  field :website

  field :birthdate , type: Date

  field :hometown #Luogo dove risiedo

  field :interests , type: String #Array????

  field :friend_list_id, type: String
  field :followers_count, type: Integer, default: 0
  field :following_count, type: Integer, default: 0

  field :group_ids, type: Array, default: []
  field :attending_ids, type: Array, default: []
  field :follower_ids, type: Array, default: []


  #paginates_per 8

  mount_uploader :picture, PictureUploader

  embeds_one :location, as: :locatable
  accepts_nested_attributes_for :location
  has_many :memberships, :class_name => "Membership", :validate => false

  has_many :created_events, inverse_of: :creator, class_name: "Event", :dependent => :destroy, :validate => false
  has_many :attending_events, inverse_of: :attendee, class_name: "Event"
  belongs_to :friend_list
  belongs_to :invitation

  before_create :initialize_fields


  def initialize_fields
    self.friend_list = FriendList.create if self.friend_list.nil?

    if self.location.nil?
      self.location = Location.new
    end
  end

  def admin?
    self.role == "admin"
  end

  #TODO: MOVE TO CANCAN Abilities
  def can_modify?(model)
    return false unless model.respond_to?(:user)
    self.admin? || self == model.creator
  end

  def following?(user)
    FriendList.only(:following_ids).where(:_id => self.friend_list_id).first.following_ids.include?(user.id)
  end

  #EVENTS

  def invited_events(limit=5)
    Event.where( :invited_ids => self.id ).limit(limit)
  end

  def suggested_events #events category match user interests

  end

  def creator_of?(event)
    admin? || event.creator_id == self.id
  end

  def can_modify?(event)
    creator_of?(event) || ( event.group and event.group.owner_id == self.id )
  end
  #GROUPS
  def config_for(group, init = false)
    membership_selector_for(group).first
  end

  def membership_selector_for(group)
    if group.kind_of?(Group)
      group = group.id
    end

    Membership.unscoped.where(:user_id => self.id, :group_id => group)
  end


  def join(group, &block)
    if !self.member_of? group
      if group.kind_of?(Group)
        group = group.id
      end

      membership = config_for(group)
      if membership.nil?
        membership = Membership.new({
                                      :user_id => self.id,
                                      :group_id => group,
                                      :last_activity_at => Time.now,
                                      :joined_at => Time.now
        })
      else
        membership.state = 'active'
        membership.save
      end
      self.group_ids << group
      block.call(membership) if block

      membership
    end
  end

  def join!(group, &block)
    if membership = join(group, &block)
      membership.save!
      self.save!
    end
  end

  def leave(group)
    if group.kind_of?(Group)
      group = group.id
    end

    membership = config_for(group)
    if membership
      membership.state = 'inactive'
      membership.save
      self.pull( group_ids:  group)
      user = User.find(self.id)
    end
  end

  def member_of?(group)
    if group.kind_of?(Group)
      group = group.id
    end

    self.group_ids.include?(group)
  end

  def role_on(group)
    if config = config_for(group, false)
      config.role
    end
  end

  def owner_of?(group)
    admin? || group.owner_id == self.id || role_on(group) == "owner"
  end

  def admin_of?(group)
    role_on(group) == "admin" || owner_of?(group)
  end

  def mod_of?(group)
    admin_of?(group) || role_on(group) == "moderator"
  end

  def owned_groups(limit=0)
    Group.where(:owner_id => self.id).limit(limit)
  end

  def attending_events(limit=0)
    Event.where(:_id.in => self.attending_ids)
  end


  def followed_groups(limit=0)
    Group.where(:_id.in => self.group_ids)
  end


  # User <> User relations
  def add_friend(user)
    return false if user == self
    user.friend_list.push(follower_ids: self.id)
    self.friend_list.push(following_ids: user.id)
    self.inc(following_count: 1)
    user.inc(followers_count: 1)
    true
  end

  def remove_friend(user)
    return false if user == self
    user.friend_list.pull(follower_ids: self.id)
    self.friend_list.pull(following_ids: user.id)

    self.inc(following_count: -1)
    user.inc(followers_count: -1)
    true
  end

  def followers
    User.where(:_id.in => self.friend_list.follower_ids)
  end

  def following
    User.where(:_id.in => self.friend_list.following_ids)
  end

  def following?(user)
    FriendList.only(:following_ids).where(:_id => self.friend_list_id).first.following_ids.include?(user.id)
  end

  def friends
    User.where(:_id.in => self.friend_list.follower_ids).where(:_id.in => self.friend_list.following_ids)
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          picture: auth.info.image,
          hometown: auth.info.location,
          website: auth.extra.raw_info.link
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
