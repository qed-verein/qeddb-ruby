module SelectHelper
  def default_options(placeholder, non_found)
    { class: 'slim-select', 'data-select-search-placeholder': placeholder, 'data-select-search-non-found': non_found }
  end

  def searchable_collection_select(form_entry, id, collection, value_getter, text_getter, blank: nil,
                                   html_options: {}, placeholder: '', non_found: '')
    options = {}
    options[:include_blank] = blank unless blank.nil?
    html_options = (default_options placeholder, non_found).merge(html_options)

    form_entry.collection_select(id, collection, value_getter, text_getter, options, html_options)
  end

  def searchable_form_select(form, id, choices, options, html_options: {}, placeholder: '', non_found: '')
    html_options = (default_options placeholder, non_found).merge(html_options)

    form.select id, choices, options, html_options
  end

  def searchable_select(id, choices, html_options: {}, placeholder: '', non_found: '')
    html_options = (default_options placeholder, non_found).merge(html_options)

    select_tag id, choices, html_options
  end
end
