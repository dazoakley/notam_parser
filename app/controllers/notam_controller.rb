class NotamController < ApplicationController
  def index
  end

  def results
    @notams = NotamBuilder.build(params[:notam])
  end
end
