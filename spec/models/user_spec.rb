require 'rails_helper'

RSpec.describe User, :type => :model do

  describe 'when create' do

    before(:each) do
      @attrs = {
          :name => 'user',
          :email => 'user@exmaple.org',
          :password => 'secret',
          :password_confirmation => 'secret'}
    end

    it 'should create a new instance given a valid attribute' do
      User.create!(@attrs)
    end

    describe 'should be invalid with' do
      it 'empty name' do
        user = User.new(@attrs.merge(:name => ''))
        expect(user).to be_invalid
      end
      it 'long name' do
        user = User.new(@attrs.merge(:name => 'a'*100))
        expect(user).to be_invalid
      end
      it 'wrong name format' do
        user = User.new(@attrs.merge(:name => 'user#'))
        expect(user).to be_invalid
      end
      it 'empty email' do
        user = User.new(@attrs.merge(:email => ''))
        expect(user).to be_invalid
      end
      it 'wrong email format' do
        user = User.new(@attrs.merge(:email => 'user@aaa'))
        expect(user).to be_invalid
      end
    end
  end

end
