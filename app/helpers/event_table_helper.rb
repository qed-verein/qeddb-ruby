module EventTableHelper
  def checkbox(id, text, checked)
    content_tag :label do
      content_tag :input, { autocomplete: 'off', type: 'checkbox', id: id, checked: checked } do
        concat text
      end
    end
  end
end
