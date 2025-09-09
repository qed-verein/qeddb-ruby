module ApplicationHelper
  def root_link
    link_to Rails.configuration.database_title, root_path
  end

  def admin_link
    link_to 'Admin', admin_path
  end

  def navigation_path(links)
    links.join(' » ').html_safe
  end

  def unknown_html
    '<i>unb.</i>'.html_safe
  end

  def blank_html
    '<i>k.A.</i>'.html_safe
  end

  def check_unknown(str)
    str.nil? ? unknown_html : yield(str)
  end

  def check_blank(str)
    str.blank? ? blank_html : yield(str)
  end

  def render_yes_no(boolean)
    return unknown_html if boolean.nil?

    boolean ? t(:yes) : t(:no)
  end

  def render_string(str)
    return unknown_html if str.nil?
    return blank_html if str.blank?

    str
  end

  def render_date(date)
    return time_tag date, l(date) if date.instance_of?(Date)

    check_unknown(date) { time_tag date.localtime, l(date.localtime.to_date) }
  end

  def render_datetime(time, format = :short)
    check_unknown(time) { time_tag time.localtime, l(time.localtime, format: format) }
  end

  def date_table_cell(date)
    tag.td render_date(date), data: { sort_value: date || 0 }
  end

  def money_table_cell(amount)
    tag.td check_unknown(amount) { |a| number_to_currency(a) }, data: { sort_value: amount || 0 }
  end

  def authorize_json_export(policy, json)
    if policy.export?
      yield
    else
      json.status 'error'
      json.message 'JSON-Export not allowed'
    end
  end

  def admin_email_link
    mail_to Rails.configuration.admin_email_address
  end

  def privileged_mode_link
    return unless toggle_privileged_mode?

    if session[:mode] == 'privileged'
      icon_button t('actions.admin.exit_privileged_mode'), 'lock_open', send("admin_standard_mode_path")
    else
      icon_button t('actions.admin.enter_privileged_mode'), 'lock', send("admin_privileged_mode_path")
    end
  end

  # kann user in den privilegierten Modus wechseln?
  def toggle_privileged_mode?
    current_user.admin? || current_user.chairman? || current_user.treasurer?
  end
end
