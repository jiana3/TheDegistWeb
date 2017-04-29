require 'mandrill'
class SubscriptionsController < ApplicationController
  #Process admin/email request
  def send_email      
    emails_templates = Subscription.emailing_subscription() 
    if !emails_templates.nil?    
    process_email(emails_templates)     
    update_user_last_article(emails_templates)
    end
    render :layout => false  
   end   
  # Get html based on the articles retrieved from the template. Render option only available on the controller side
  def get_html(template)
    if !template.articles.empty?
      html = render_to_string(:template => 'subscriptions/template_interest.html.erb', :locals => { :templates => template } , :layout => false)
    else
      html = "You don't have new content available. </br> We will return with news of your interest!!!"
    end
    return html
  end  
  # Get list of recipients to send to Mandrill API
  def convert_users_to_mandrill_recipients(templates)
     templates.map do |user|     
     {:email => user.email}
     end
  end
  # Send emails
  def process_email(templates)
    # send a new message
    m = Mandrill::API.new
    message = { 
      :subject=> "News from The Digest", 
      :from_name=> "TheDigest",
      :from_email=>"hello@thedigest.com",
      :to=>convert_users_to_mandrill_recipients(templates),
      :html=>render_to_string('subscriptions/template_email.html.erb', :layout => false), 
      :merge_vars => to_mandrill_merge_vars(templates),
      :preserve_recipients => false
    } 
    sending = m.messages.send message
  end    
  # Merge templates with vars
  def to_mandrill_merge_vars(templates) 
    templates.map {|template| {:rcpt => template.email, :vars => [{:name => 'first_name', :content => template.name},{:name => 'body', :content => get_html(template)}]}} 
  end
  # Update the last_article_id send to a user
  def update_user_last_article(templates)  
    templates.each do |template|
      if template.last_article_id > 0
        user = User.find(template.user_id)  
        user.update_attribute(:last_article_id, template.last_article_id)  
      end 
  end 
 end
end
