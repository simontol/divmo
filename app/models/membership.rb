class Membership
  #User è un membro del Group con ruolo user, moderator
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w[admin user moderator]
  
  default_scope ->{where(:state => "active")}
  
  field :state, :type => String, :default => 'active'
  field :user_name
  field :group_id
  field :events_count , type: Integer
  field :last_activity_at, type: Time
  field :joined_at, type: Time
  field :role, :type => String , :default => "user"
  
  belongs_to :user
  belongs_to :group
  
  validates_inclusion_of :role,  :in => ROLES
  validates_presence_of :user
  validates_presence_of :group
  validates_uniqueness_of :user_id, :scope => [:group_id]
  
  #index :group_id
  #index :user_id
  #index :state
  
end
