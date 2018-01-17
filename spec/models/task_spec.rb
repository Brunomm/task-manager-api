require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { build(:task) }

  context 'When is new' do
    it { expect(subject).not_to be_done }
  end

  describe 'table informations' do
    describe 'attributes' do
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:description).of_type(:text) }
      it { should have_db_column(:user_id).of_type(:integer) }
      it { should have_db_column(:deadline).of_type(:datetime) }
      it { should have_db_column(:done).of_type(:boolean).with_options(default: false) }
      it { should have_db_column(:user_id).of_type(:integer) }
    end

    describe 'index' do
      it { should have_db_index(:user_id) }
    end
  end


  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user) }
  end
end