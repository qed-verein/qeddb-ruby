module HostelsHelper

include LinksHelper
default_crud_links :hostel
	
def hostel_homepage_link(hostel)
	if hostel.homepage.blank?
		return hostel.title
	else
		return link_to hostel.title, hostel.homepage
	end
end

def hostel_select(form)
	hostels = Hostel.order('title ASC').all.map {|h| [h.title, h.id]}
	form.select :hostel_id, hostels, id: :hostel_id, :include_blank => "nicht angegeben"
end

end
