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
end

class Community <ActiveRecord::Base
has_many :users,through: :user_communities
end

class UserCommunity < ActiveRecord::Base#中間テーブル
  belongs_to :user
  belongs_to :community
end