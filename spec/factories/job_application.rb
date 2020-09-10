FactoryBot.define do
  factory :job_application do
    candidate_id {FactoryBot.create(:user).id}
    recruiter_id {sender = FactoryBot.create(:user); sender.remove_role :candidate; sender.add_role :recruiter; sender.id}
    job_post_id {FactoryBot.create(:job_post).id}
    status {"reviewing"}
  end
end
