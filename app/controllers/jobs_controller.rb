class JobsController < ApplicationController
  def index 
    @jobs = Job.all
  end

  def create

  end

  def destroy 

  end
end
