class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_comment, only: :destroy
  before_action :check_rights, only: :destroy

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = find_commentable
    respond_to do |format|
      if @comment.save
        format.js   { render 'replace', status: :created, location: @comment.commentable }
      else
        format.js   { render json: @comment.errors, status: :unprocessable_entity }
      end
      format.html { redirect_to @comment.commentable }
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.commentable }
      format.js   { render 'replace' }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def set_comment
    @comment = find_commentable.comments.find(params[:id])
  end

  def check_rights
    @comment.can_be_destroyed_by?(current_user)
  end
end
