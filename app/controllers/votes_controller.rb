class VotesController < ApplicationController
  before_action :signed_in_user
  before_action :set_vote, only: :destroy
  before_action :check_rights, only: :destroy

  def create
    @vote = current_user.votes.new()
    @vote.voteable = find_voteable
    respond_to do |format|
      if @vote.save
        format.js   { render 'replace', status: :created, location: @vote.voteable }
      else
        format.js   { render json: @vote.errors, status: :unprocessable_entity }
      end
      format.html { redirect_to @vote.voteable }
    end
  end

  def destroy
    @vote.destroy
    respond_to do |format|
      format.html { redirect_to @vote.voteable }
      format.js   { render 'replace' }
    end
  end

  private

  def find_voteable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def set_vote
    @vote = find_voteable.votes.find(params[:id])
  end

  def check_rights
    @vote.can_be_destroyed_by?(current_user)
  end
end
