# == Schema Information
#
# Table name: clients
#
#  id                 :integer          not null, primary key
#  user_id            :integer          indexed
#  external_id        :string(255)      indexed => [reseller_id]
#  name               :string(255)
#  email              :string(255)
#  language           :string(255)
#  slug               :string(255)      indexed
#  token              :string(255)      indexed
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reseller_id        :integer          indexed, indexed => [external_id]
#  sign_in_count      :integer          default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#

FactoryGirl.define do

  factory :client do
    name 'McKinsey'
    email 'mckinsey@example.com'
    language 'en'
    external_id '639141'
  end

end
