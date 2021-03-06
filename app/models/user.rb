class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: %i[label artist]

  has_one :artist, dependent: :destroy
  has_one :label, dependent: :destroy

  has_many :connections_as_user1, class_name: "Connection", foreign_key: :user2_id, dependent: :destroy
  has_many :followees, through: :connections_as_user1, source: :user1

  has_many :connections_as_user2, class_name: "Connection", foreign_key: :user1_id, dependent: :destroy
  has_many :followers, through: :connections_as_user2, source: :user2

  has_many :messages, dependent: :destroy
  has_many :chatrooms, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :posts, dependent: :destroy

  def my_chatrooms
    chatrooms + conversations.map { |conversation| conversation.chatroom }
  end

  def follow(user)
    connections_as_user1.create!(user1: user)
  end

  def unfollow(user)
    connections_as_user1.find_by(user1: user).destroy
  end

  def following?(user)
    @user = User.find(user.id)
    followees.include?(@user)
  end

  def following_connection(user)
    connections_as_user1.find_by(user1: user)
  end

  def connections
    connections_as_user1 + connections_as_user2
  end

  def chatroom_with(user)
    chatrooms.find { |chatroom| chatroom.conversations.any? { |conversation| conversation.user == user } }
  end

  def profile_instance
    label? ? label : artist
  end

  def profile_path
    if label?
      Rails.application.routes.url_helpers.label_path(label)
    else
      Rails.application.routes.url_helpers.artist_path(artist)
    end
  end
end
