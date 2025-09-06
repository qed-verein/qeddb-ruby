class MailinglistsController < ApplicationController
  breadcrumb Mailinglist.model_name.human(count: :other), :mailinglists_path

  before_action :set_mailinglist, except: %i[index new create]
  before_action :basic_authorization

  def index
    @mailinglists = Mailinglist.all
  end

  def show; end

  def new
    @mailinglist = Mailinglist.new
  end

  def create
    @mailinglist = Mailinglist.new(permitted_attributes(Mailinglist))
    if @mailinglist.save
      redirect_to @mailinglist, notice: t('.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @mailinglist.update(permitted_attributes(@mailinglist))
      redirect_to @mailinglist, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @mailinglist.destroy
    redirect_to mailinglists_url, notice: t('.success')
  end

  private

  def set_mailinglist
    @mailinglist = Mailinglist.find(params[:id])
    @mailinglist_policy = policy(@mailinglist)
    breadcrumb @mailinglist.title, @mailinglist
  end

  def basic_authorization
    authorize(@mailinglist.nil? ? Mailinglist : @mailinglist)
  end
end
