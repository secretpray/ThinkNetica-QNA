require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :show? do
    # pending "add some examples to (or delete) #{__FILE__}"
  end
end
