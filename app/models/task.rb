class Task < ApplicationRecord
  belongs_to :user
  validates :title, :user, presence: true

  def late?
    deadline ? deadline < Time.current : false
  end

  def short_description
    "#{description}"[0..15]
  end
end
