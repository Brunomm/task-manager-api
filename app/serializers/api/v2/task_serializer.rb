class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :deadline, :created_at, :updated_at, :user_id,
             :done, :is_late, :short_description
  def is_late
    object.late?
  end
end
