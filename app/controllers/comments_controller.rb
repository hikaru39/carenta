class CommentsController < ApplicationController
  def create
    item = Item.find_by(id: params[:item_id])
    @comment = item.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path, notice: "コメントの投稿に失敗しました。")
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
