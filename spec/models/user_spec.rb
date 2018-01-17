require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validation' do
    # it { expect(subject).to validate_presence_of(:name) }
    # it { is_expected.to validate_presence_of(:name) }
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('bruno@mergen.co').for(:email) }
    it { should validate_confirmation_of(:password) }
    it { should validate_uniqueness_of(:auth_token) }

    describe '#info' do
      it "returns email and created_at and a Token" do
        subject.save!
        allow(Devise).to receive(:friendly_token).and_return('asd8u129eh91')
        expect(subject.info).to eq("#{subject.email} - #{subject.created_at} - Token: asd8u129eh91")
      end
    end

    describe '#generate_authentication_token!' do
      it 'generates a unique auth_token' do
        allow(Devise).to receive(:friendly_token).and_return('asd8u129eh91')
        subject.generate_authentication_token!
        expect(subject.auth_token).to eq('asd8u129eh91')
      end
      it 'generates another auth token when the current auth token already ha been taken' do
        allow(Devise).to receive(:friendly_token).and_return('2983432923j98923', '2983432923j98923', 'abcuah8h7')
        existing_user = create(:user)
        subject.generate_authentication_token!
        expect(subject.auth_token).to eq('abcuah8h7')
      end
      it 'will be called before creating' do
        expect(subject).to receive(:generate_authentication_token!)
        subject.run_callbacks(:create){ false }
      end
    end
  end
end