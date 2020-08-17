class CommentsController < ApplicationController
    def create
        @user = @comment.user
        @comment = Comment.create(comment_params)
        redirect_to user_path(@user)
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :post_id, :user_id)
    end
end
