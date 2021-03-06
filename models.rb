require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User <ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness:true ,format:{with:/[@]/}
  has_many :communities,through: :user_communities
  has_many :teams,through: :user_teams
end

class Community <ActiveRecord::Base
has_many :users,through: :user_communities
end

class UserCommunity < ActiveRecord::Base#中間テーブル
  belongs_to :user
  belongs_to :community
  scope :belonging, -> (user){where(user_id: user.id)}
end

class Team <ActiveRecord::Base
has_many :users,through: :user_teams
end

class UserTeam < ActiveRecord::Base#中間テーブル
  belongs_to :user
  belongs_to :team
  scope :members, -> (team){where(team_id:team.id)}
  scope :belonging, -> (user){where(user_id: user.id)}
end

class Product <ActiveRecord::Base
   belongs_to :team
end