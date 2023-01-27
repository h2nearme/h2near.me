class Suppliers::BaseController < ApplicationController
  before_action :authenticate_supplier!
end