# frozen_string_literal: true

class HostelsController < ApplicationController
  breadcrumb Hostel.model_name.human(count: :other), :hostels_path

  before_action :set_hostel, except: %i[index new create]
  before_action :basic_authorization

  def index
    @hostels = Hostel.all
  end

  def show; end

  def new
    @hostel = Hostel.new
    @hostel.build_address
  end

  def create
    @hostel = Hostel.new(permitted_attributes(Hostel))
    if @hostel.save
      redirect_to @hostel, notice: t('.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @hostel.update(permitted_attributes(@hostel))
      redirect_to @hostel, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @hostel.destroy
    redirect_to hostels_url, notice: t('.success')
  end

  private

  def set_hostel
    @hostel = Hostel.find(params[:id])
    @hostel_policy = policy(@hostel)
    breadcrumb @hostel.title, @hostel
  end

  def basic_authorization
    authorize(@hostel.nil? ? Hostel : @hostel)
  end
end
