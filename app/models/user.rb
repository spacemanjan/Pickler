class User < ActiveRecord::Base
    
    has_many :posts
    has_many :comments
    has_many :likes
    
    validates_presence_of :avatar_url, :username, :password
    validates_uniqueness_of :username

end