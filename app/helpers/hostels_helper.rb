module HostelsHelper
  include LinksHelper

  default_crud_links :hostel

  def hostel_homepage_link(hostel)
    return hostel.title if hostel.homepage.blank?

    link_to hostel.title, hostel.homepage
  end

  def hostel_select(form)
    hostels = Hostel.order(:title).all.map { |h| [h.title, h.id] }
    form.select :hostel_id, hostels, id: :hostel_id, include_blank: 'nicht angegeben'
  end
end
