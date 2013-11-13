class ContactController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def submit_message
    AdminMailer.message_email(params[:name], params[:email], params[:comment]).deliver
    render text: "1"
  end

end
