module VersionsHelper

include Pagy::Frontend

# Art des Objekts, welches in dieser Version geändert wurde
def item_type(version)
	klass = version.item_type.constantize
	klass.model_name.human
end

# Kurzer Name des Objekts, welches in dieser Version geändert wurde
def item_name(version)
	klass = version.item_type.constantize
	current_version = klass.find_by(id: version.item_id)

	object = current_version || (version.next && version.next.reify) || version.reify
	return version.item_type + "#" + version.item_id.to_s unless object

	object.object_name
end

def versions_link
	return nil unless policy(:version).index?
	link_to t('activerecord.models.version', count: :other), versions_path
end

def version_link(version)
	return nil unless policy(version).show?
	link_to sprintf("%s %d - rev %d", version.item_type, version.item_id, version.index), version_path(version)
end

def revert_link(version)
	link_to t('actions.version.revert'), revert_version_path(version), method: :patch, data: {
		confirm: sprintf("Object %s-%d auf Version %d zurücksetzen?",
			version.item_type, version.item_id, version.index)}
end

end
