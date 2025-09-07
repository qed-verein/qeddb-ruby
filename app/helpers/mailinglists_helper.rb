module MailinglistsHelper
  include LinksHelper

  default_crud_links :mailinglist, except: [:show]

  def mailinglist_link(mailinglist)
    return unless policy(mailinglist).show?

    link_to "#{mailinglist.title}@#{Rails.configuration.mailinglist_domain}", mailinglist_path(mailinglist)
  end
end
