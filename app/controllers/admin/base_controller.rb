class Admin::BaseController < ApplicationController
  before_action :require_legitbs
  layout 'admin'
end
