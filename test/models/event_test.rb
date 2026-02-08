require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def default_event_hash
    { title: 'test 2002',
      start: Time.zone.local(2002, 2, 20),
      end: Time.zone.local(2002, 2, 22),
      deadline: Time.zone.local(2002, 1, 1),
      max_participants: 20,
      cost: 100 }
  end

  def emojis_in_title
    { title: 'test🐧 2023',
      start: Time.zone.local(2023, 2, 20),
      end: Time.zone.local(2023, 2, 22),
      deadline: Time.zone.local(2002, 1, 1),
      max_participants: 20,
      cost: 100 }
  end

  def umlaute_in_title
    { title: 'testäöüøåß 2023',
      start: Time.zone.local(2023, 2, 20),
      end: Time.zone.local(2023, 2, 22),
      deadline: Time.zone.local(2002, 1, 1),
      max_participants: 20,
      cost: 100,
      mailinglist_slug: 'umlaute23'
    }
  end

  def long_title
    { title: 'Dampfschifffahrtskapitänsmützenbandakademie 2023',
      start: Time.zone.local(2023, 2, 20),
      end: Time.zone.local(2023, 2, 22),
      deadline: Time.zone.local(2002, 1, 1),
      max_participants: 20,
      cost: 100,
    }
  end

  test 'create_event' do
    assert_nothing_raised { Event.create!(default_event_hash) }
  end

  test 'emojis are allowed in title' do
    assert_nothing_raised { Event.create!(emojis_in_title) }
  end

  test 'umlauts are allowed in title' do
    assert_nothing_raised { Event.create!(umlaute_in_title) }
  end

  test 'update_event' do
    event = nil
    assert_nothing_raised do
      event = Event.find_by(title: 'Mathematikerkonferenz')
      event.cost = 3
      event.max_participants = 43
      event.save!
    end
    event_new = nil
    assert_nothing_raised { event_new = Event.find_by(title: 'Mathematikerkonferenz') }
    assert(event_new.cost == '3')
    assert(event_new.max_participants == 43)
  end

  test 'delete_event' do
    assert_nothing_raised { Event.find_by(title: 'Mathematikerkonferenz').destroy! }
  end

  test 'time_ordering' do
    assert_raise(ActiveRecord::RecordInvalid) do
      Event.create!(default_event_hash.merge(start: Time.zone.local(2002, 2, 22), end: Time.zone.local(2002, 2, 20)))
    end
  end

  test 'reference_line_gets_generated_if_missing' do
    event = Event.create!(default_event_hash)
    assert_not_nil(event.reference_line)
  end

  test 'mailinglist_slug_gets_generated_if_missing' do
    event = Event.create!(default_event_hash)
    assert_not_nil(event.mailinglist_slug)
  end

  test 'mailing_list_generated_from_long_title_complains_about_being_too_long' do
    error = assert_raise(ActiveRecord::RecordInvalid) do
      Event.create!(long_title)
    end
    assert_match(/#{Event.human_attribute_name(:mailinglist_slug)} ist zu lang/i, error.message)
  end

  test 'reference_line_generated_from_long_title_complains_about_being_too_long' do
    error = assert_raise(ActiveRecord::RecordInvalid) do
      Event.create!(long_title)
    end
    assert_match(/#{Event.human_attribute_name(:reference_line)} ist zu lang/i, error.message)
  end



end
