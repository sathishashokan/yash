class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
    after_create :notify_slack
    after_update :notify_slack_update

    private

    def notify_slack
        SlackNotifier::CLIENT.ping("🎉 New user: #{email} 🎉")
    end

    def notify_slack_update
        SlackNotifier::CLIENT.ping("🎉 User updated: #{email}🎉")
    end
end
