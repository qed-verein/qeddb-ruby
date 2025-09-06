module ChargeModifiersHelper
  def charge_modifier_reasons
    %i[talk_discount course_discount external_surcharge organizer_discount partial_stay_discount
       event_report_discount main_building_surcharge]
  end
end
