require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'when create' do
    it 'should create a new instance given a valid attribute' do
      expect{ create(:user) }.to change { User.count }.by(1)
    end

    describe 'should be invalid with' do
      it 'empty name' do
        user = build(:user, :name => '')
        expect(user).to be_invalid
      end
      it 'long name' do
        user = build(:user, :name => 'a'*100)
        expect(user).to be_invalid
      end
      it 'wrong name format' do
        user = build(:user, :name => 'user#')
        expect(user).to be_invalid
      end
      it 'empty email' do
        user = build(:user, :email => '')
        expect(user).to be_invalid
      end
      it 'long email' do
        user = build(:user, :email => "#{'a'*100}@example.org")
        expect(user).to be_invalid
      end
      it 'wrong email format' do
        user1 = build(:user, :email => 'user@example')
        user2 = build(:user, :email => 'userexample.org')
        user3 = build(:user, :email => '#user@example.org')
        expect(user1).to be_invalid
        expect(user2).to be_invalid
        expect(user3).to be_invalid
      end
      it 'short password' do
        user = build(:user, :password => '12345', :password_confirmation => '12345')
        expect(user).to be_invalid
      end
      it 'to long password' do
        user = build(:user, :password => '12345'*10, :password_confirmation => '12345'*10)
        expect(user).to be_invalid
      end
      it 'not matched password_confirmation' do
        user = build(:user, :password_confirmation => '')
        expect(user).to be_invalid
      end
      it 'duplicate name' do
        user1 = create(:user)
        user2 = build(:user, :name => user1.name)
        expect(user2).to be_invalid
      end
      it 'duplicate email' do
        user1 = create(:user)
        user2 = build(:user, :email => user1.email)
        expect(user2).to be_invalid
      end
    end
  end
end
