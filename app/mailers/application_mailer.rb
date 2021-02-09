class ApplicationMailer < ActionMailer::Base
	helper ApplicationHelper
	default from: Rails.configuration.system_email_address, 
		reply_to: Rails.configuration.admin_email_address
	layout 'mailer'
end
