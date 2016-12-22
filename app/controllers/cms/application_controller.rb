class Cms::ApplicationController < ApplicationController
  # layout 'purple/application'
  theme "purple"
  private

  def authorized?
    return true
  end
end
