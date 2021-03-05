# frozen_string_literal: true

class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :query)
  end
end
