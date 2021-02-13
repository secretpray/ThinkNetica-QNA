# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of(:score) }
  it { should validate_inclusion_of(:score).in_array([1, 0, -1]) }
  it { should validate_numericality_of(:score) }
  subject { create(:vote, :for_question) }
  it { should validate_uniqueness_of(:user).scoped_to(:votable_id, :votable_type).with_message("** DOUBLE ERROR **") }
end