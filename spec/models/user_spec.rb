require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to be_valid }

  describe 'validation' do
    # it { expect(subject).to validate_presence_of(:name) }
    # it { is_expected.to validate_presence_of(:name) }
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('bruno@mergen.co').for(:email) }
    it { should validate_confirmation_of(:password) }
  end
end