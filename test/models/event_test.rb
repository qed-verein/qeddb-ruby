require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def default_event_hash
    { title: 'Testveranstaltung',
      start: Time.zone.local(2002, 2, 20),
      end: Time.zone.local(2002, 2, 22),
      deadline: Time.zone.local(2002, 1, 1),
      max_participants: 20,
      cost: 100 }
  end

  test 'create_event' do
    assert_nothing_raised { Event.create!(default_event_hash) }
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
end
