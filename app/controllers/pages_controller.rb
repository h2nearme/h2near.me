class PagesController < ApplicationController
  def home
    @supplier_locations = SupplierLocation.all
  end

  def about
  end

  def terms_and_conditions
  end

  def privacy_statement
  end

end