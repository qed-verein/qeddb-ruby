# frozen_string_literal: true

class AddReferenceLineToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :reference_line, :string
  end
end
