require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def default_person_hash
    { first_name: 'Test', last_name: 'User',
      account_name: 'TestUser', birthday: Time.new(2000, 1, 1),
      email_address: 'testuser@email.de', active: true,
      gender: :male,	password: 'secret', password_confirmation: 'secret' }
  end

  test 'create person' do
    assert_nothing_raised { Person.create!(default_person_hash) }
  end

  test 'unique account_name' do
    assert_nothing_raised do
      Person.create!(default_person_hash.merge({ account_name: 'Blub' }))
    end
    assert_raise(ActiveRecord::RecordInvalid) do
      Person.create!(default_person_hash.merge({ account_name: 'Blub' }))
    end
  end

  test 'empty password allowed' do
    assert_nothing_raised do
      Person.create!(default_person_hash.merge({ password: '', password_confirmation: '' }))
    end
  end

  test 'password required' do
    assert_raise(ActiveRecord::RecordInvalid) do
      Person.create!(default_person_hash.merge({ password: 'X', password_confirmation: 'X' }))
    end
    assert_raise(ActiveRecord::RecordInvalid) do
      Person.create!(default_person_hash.merge({ password: 'Kaenguruh', password_confirmation: 'Kaenguru' }))
    end
    assert_nothing_raised do
      Person.create!(default_person_hash.merge({ password: 'Kaenguruh', password_confirmation: 'Kaenguruh' }))
    end
  end
end
