class Offtakers::BaseController < ApplicationController
  before_action :authenticate_offtaker!
end