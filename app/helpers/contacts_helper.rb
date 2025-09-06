module ContactsHelper
  def im_protocol_list
    %w[Discord Email Facebook Github GPG ICQ Instagram IRC Jabber Matrix Mobil
       Mumble Signal Skype Teamspeak Telegram Telefon Twitter Whatsapp Youtube XMPP]
  end

  def mobile_phone_html(number)
    link_to number, "tel:#{number}"
  end

  def xmpp_address_html(address)
    link_to address, "xmpp:#{address}"
  end

  def email_address_html(address)
    link_to address, "mailto:#{address}"
  end

  def telegram_html(address)
    link_to "@#{address}", "https://t.me/#{CGI.escape(address)}"
  end

  def contact_html(contact)
    protocol = contact.protocol.split.first.strip.downcase
    case protocol.strip.downcase
    when 'telefon', 'mobil', 'handy'
      mobile_phone_html(contact.identifier)
    when 'email'
      email_address_html(contact.identifier)
    when 'jabber', 'xmpp'
      xmpp_address_html(contact.identifier)
    when 'telegram'
      telegram_html(contact.identifier)
    else
      contact.identifier
    end
  end
end
