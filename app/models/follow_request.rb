class FollowRequest < ApplicationRecord
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

  enum status: { pending: "pending", rejected: "rejected", accepted: "accepted" }

  
end
