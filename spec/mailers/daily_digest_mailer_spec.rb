require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user, created_at: Time.now) }
  let!(:answer) { create(:answer, user: user, question: questions.first) }

  describe "digest" do
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:questions_titles) { questions.map(&:title).join(', ') }

    it "renders the headers" do
      expect(mail.subject).to eq("Yesterday questions from QNA")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("daily questions list from QNA for yesterday")
    end
  end
end
