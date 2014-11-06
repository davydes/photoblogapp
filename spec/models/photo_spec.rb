require 'rails_helper'

RSpec.describe Photo, :type => :model do
  describe 'when create' do
    it 'should create a new instance given a valid attribute' do
      expect{ create(:photo) }.to change { Photo.count }.by(1)
    end

    describe 'should be invalid with' do
      it 'user empty' do
        expect(build(:photo, :user => nil)).to be_invalid
      end
      it 'title too long' do
        expect(build(:photo, :title => 'a'*51)).to be_invalid
      end
      it 'description too long' do
        expect(build(:photo, :description => 'a'*251)).to be_invalid
      end
      it 'presence image' do
        expect(build(:photo, :image => nil)).to be_invalid
      end
      it 'incorrect image content type' do
        expect(build(:photo, :image_content_type => 'application/pdf')).to be_invalid
      end
      it 'image too small' do
        expect(build(:photo, :image_file_size => 99.kilobyte)).to be_invalid
      end
      it 'image too big' do
        expect(build(:photo, :image_file_size => 6.megabyte)).to be_invalid
      end
      it 'daily quota per user' do
        user = create(:user)
        5.times do
          create(:photo, :user => user)
        end
        expect(build(:photo, :user => user)).to be_invalid
      end
      describe 'weekly quota per user' do
        before do Timecop.freeze(Time.now.beginning_of_week) end
        after  do Timecop.return end

        it '' do
          user = create(:user)
          expect {
            3.times do
              5.times { create(:photo, :user => user) }
              Timecop.freeze(Time.now+1.day)
            end
          }.to change{ Photo.count }.by(15)
          Timecop.freeze(Time.now+1.day)

          expect(build(:photo, :user => user)).to be_invalid
        end

      end
    end
  end

  describe 'when update' do
    before (:all) do
      @photo = create(:photo)
    end

    describe 'should update with valid attr' do
      it 'title' do
        @photo.title = 'Test'
        @photo.save!
        expect(@photo).to be_valid
      end
      it 'description' do
        @photo.description = 'Test Description'
        @photo.save!
        expect(@photo).to be_valid
      end
    end
  end
end
