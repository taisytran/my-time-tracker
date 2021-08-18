class WelcomeController < ApplicationController
  # respond_to :js, :html

  # GET welcome.json
  # GET welcome.html
  # GET welcome.csv
  # GET welcome.js # make sure requset with AJAX
  # GET welcome.xml
  def index
    json = {a: 1}
    respond_to do |format|
      format.html { render :index }
      format.json  { render :json => json }
      format.csv   { render :csv => json.to_csv }
      format.js
      format.xml  { render :xml => json.to_xml }
    end
    # respond_with(json)
  end
end
