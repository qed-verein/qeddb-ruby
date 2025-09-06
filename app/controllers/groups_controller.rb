# frozen_string_literal: true

class GroupsController < ApplicationController
  breadcrumb Group.model_name.human(count: :other), :groups_path

  before_action :set_group, except: %i[index new create]
  before_action :basic_authorization

  def index
    @groups = Group.where(event: nil).all
  end

  def show; end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(permitted_attributes(Group))
    if @group.save
      redirect_to @group, notice: t('.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @group.update(permitted_attributes(@group))
      redirect_to @group, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: t('.success')
  end

  private

  def set_group
    @group = Group.find(params[:id])
    @group_policy = policy(@group)
    breadcrumb @group.title, @group
  end

  def basic_authorization
    authorize(@group.nil? ? Group : @group)
  end
end
