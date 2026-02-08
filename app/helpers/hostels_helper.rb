module HostelsHelper
  include LinksHelper

  default_crud_links :hostel

  def hostel_homepage_link(hostel)
    return hostel.title if hostel.homepage.blank?

    link_to hostel.title, hostel.homepage
  end

  def hostels_for_select
    Hostel.order(:title).all.map { |h| [h.title, h.id] }
  end
end
