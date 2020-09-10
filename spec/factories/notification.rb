FactoryBot.define do
  factory :notification do
    sender_id {FactoryBot.create(:user).id}
    receiver_id {sender = FactoryBot.create(:user); sender.remove_role :candidate; sender.add_role :recruiter; sender.id}
    message {[0, 1].sample}
    job_application_id {FactoryBot.create(:job_application).id}
  end
end
