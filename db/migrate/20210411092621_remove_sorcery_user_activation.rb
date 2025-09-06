# frozen_string_literal: true

class RemoveSorceryUserActivation < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :activation_state
    remove_column :people, :activation_token
    remove_column :people, :activation_token_expires_at
  end
end
