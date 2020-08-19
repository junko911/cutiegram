class TagsController < ApplicationController
    private

    def tag_params
        params.require(:tag).permit(:name, :query)
    end
end
