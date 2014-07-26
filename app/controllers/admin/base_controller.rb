class Admin::BaseController < ApplicationController
  before_filter :require_legitbs
  layout 'admin'
end
