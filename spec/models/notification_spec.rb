require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "validations" do
    context "when all required field are given" do
      let(:notification){FactoryBot.build :notification}
      it "should be true" do
        expect(notification.valid?).to eq true
      end
    end
  end

  describe "scopes" do
    describe "#desc_order" do
      let!(:notification){FactoryBot.create :notification}
      it "should order by date" do
        expect(Notification.desc_order.limit(1)).to eq [notification]
      end
    end
  end
end
