class AccountMailer < ApplicationMailer
	
	def reset_password_email(person)
		@person = person
		@url = edit_password_reset_url(@person.reset_password_token)
		mail(:to => @person.email_address, :subject => "Passwort zurücksetzen")
	end
	
	def activation_needed_email(person)
		@person = person
		@url = activate_person_url(@person.activation_token)
		mail(:to => @person.email_address, :subject => "Bitte Anmeldung bestätigen")
	end
	
	def activation_success_email(person)
		@person = person
		@url = login_url(@person)
		mail(:to => @person.email_address, :subject => "Account wurde aktiviert")
	end
	
	#def edit_email_confirm_email(person)
		#@person = person
		#@url = confirm_email_person_url(@person.activation_token)
		#mail(:to => @person.email_address, :subject => "Bitte Änderung der Emailadresse bestätigen")
	#end
	
	#def edit_email_success_email(person)
		#@person = person
		#@url = person_url(@person)
		#mail(:to => @person.email_address, :subject => "Änderung der Emailadresse wurde bestätigt")
	#end
end
