class PublicPagesController < ApplicationController
  skip_before_action :ensure_minimum_role

  def closed
    @public_pages = true
  end
end
