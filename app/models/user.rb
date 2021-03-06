# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string(255)
#  token      :string(255)      indexed
#

class User < ActiveRecord::Base
  has_many :videos, :dependent => :destroy
  has_many :video_requests, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true

  attr_accessible :name, :slug, :language, :token
  after_validation :generate_slug, on: :create
  after_validation :generate_token, on: :create

  has_many :clients

  def generate_slug
  	return unless slug.blank?
    record = true
    while record
      random = Array.new(8){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
      record = User.find_by_slug(random)
    end          
    self.slug = random
  end

  def generate_token
    return unless token.blank?
    record = true
    while record
      random = SecureRandom.urlsafe_base64(16)
      record = User.find_by_token(random)
    end
    self.token = random
  end
end
