class DailyDigestService

  def send_digest
    User.find_each(batch_size: 500) do |user|
      # DailyDigestMailer.digest(user).deliver! # for test only
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
