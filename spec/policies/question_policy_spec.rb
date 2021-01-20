require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :create? do
    # pending "add some examples to (or delete) #{__FILE__}"
  end

end
