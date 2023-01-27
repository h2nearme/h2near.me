class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "volta", password: "s72"
end
