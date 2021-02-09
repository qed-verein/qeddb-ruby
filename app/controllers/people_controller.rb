class PeopleController < ApplicationController
	include PeopleHelper

	breadcrumb Person.model_name.human(count: :other), :people_path

	before_action :set_all_people, only: [:index, :index_as_table]
	before_action :set_person, only: [:show, :addresses, :registrations, :privacy, :payments, :groups,
		:edit, :edit_addresses, :edit_privacy, :edit_payments, :edit_groups, :update, :destroy]
	before_action :basic_authorization
	skip_before_action :require_login, only: [:activate]

	def index
	end

	def index_as_table
		render "as_table"
	end

	# TODO Optimierung mit "include"
	def show
	end

	def edit
	end

	def edit_addresses
	end

	def edit_privacy
	end

	def edit_payments
	end

	def edit_groups
	end

	def new
		@person = Person.new
		@person_policy = policy(@person)
	end

	def create
		@person = Person.new(permitted_attributes(Person))
		@person_policy = policy(@person)
		#~ @person.skip_activation_needed_email = false
		if @person.save
			@person.activate!
			redirect_to @person, notice: t('.success')
		else
			render :new
		end
	end

	def update
		if @person.update(permitted_attributes(@person))
			redirect_to @person, notice: t('.success')
		else
			pages = ['edit', 'edit_addresses', 'edit_payments', 'edit_privacy']
			action = pages.include?(params[:formular]) ? params[:formular] : 'edit'
			render action
		end
	end

	def destroy
		authorize @person, :delete_person?
		@person.destroy
		redirect_to people_url, notice: t('.success')
	end

	# Die Erstellung des Accounts wurde bestätigt
	def activate
		@person = Person.load_from_activation_token(params[:id])
		if @person
			#@person.skip_activation_success_email = false
			@person.activate!
			redirect_to(login_path, :notice => "Dein Account wurde erfolgreich aktiviert")
		else
			not_authenticated
		end
	end
private
	def set_person
		@person = policy_scope(Person).find(params[:id])
		@person_policy = policy(@person)
		breadcrumb @person.full_name, @person
		breadcrumb t('actions.person.' + action_name), {action: action_name}
	end

	def set_all_people
		@people = policy_scope(Person).includes(:addresses, :contacts)
		@person_policy = policy(Person)
	end

	def basic_authorization
		case action_name.to_sym
			when :show, :registrations
				authorize @person, :view_public?
			when :privacy, :groups
				authorize @person, :view_settings?
			when :payments
				authorize @person, :view_payments?
			when :addresses
				authorize @person, :view_additional?
			when :edit, :update
				authorize @person, :edit_basic?
			when :edit_privacy
				authorize @person, :edit_settings?
			when :edit_payments
				authorize @person, :edit_payments?
			when :edit_addresses
				authorize @person, :edit_additional?
			when :new, :create
				authorize Person, :create_person?
			when :index, :index_as_table
				authorize Person, :list_published_people?
			when :destroy
				authorize @person, :delete_person?
			when :activate
				return
			else
				raise AccessDeniedException(action_name, @person)
		end
	end
end
