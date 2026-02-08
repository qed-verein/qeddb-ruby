module ButtonHelper
  def icon_button(text, icon, path)
    link_to path, class: 'button' do
      concat mi.shape(icon).md_24
      concat text
    end
  end

  def download_table_button(table)
    tag.button class: 'button', onclick: "downloadTable('#{table}')" do
      concat mi.shape(:file_download).md_24
      concat 'Herunterladen'
    end
  end

  def download_json_button(path)
    icon_button 'Als JSON anzeigen', :data_object, path
  end

  # ~ def edit_button(path)
  # ~ link_to path, class: "waves-effect waves-light btn" do
  # ~ concat tag.i(class: "material-icons left"){'edit'}
  # ~ concat "Bearbeiten"
  # ~ end
  # ~ end

  # ~ def delete_button(path, confirm)
  # ~ link_to path, class: "waves-effect waves-light btn red", method: :delete, data: {confirm: confirm} do
  # ~ concat tag.i(class: "material-icons left"){'delete'}
  # ~ concat "Löschen"
  # ~ end
  # ~ end
end
