class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "niw", password: "kier"

end
