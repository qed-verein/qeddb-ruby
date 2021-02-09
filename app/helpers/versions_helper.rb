module VersionsHelper

include Pagy::Frontend
 
def item_type(version)
	klass = version.item_type.constantize
	klass.model_name.human
end
 
def item_name(version)
	#~ klass = version.item_type.constantize
	#~ latest_version = version.reify || (version.next && version.next.reify)
	#~ return version.item_id.to_s if latest_version == nil

	klass = version.item_type.constantize
	current_version = klass.find_by(id: version.item_id) 
	
	case version.item_type
		when "Person"
			person = current_version || (version.next && version.next.reify) || version.reify
			person ? person.full_name : version.item_id
		when "Event"
			event = current_version || (version.next && version.next.reify) || version.reify
			event ? event.title : version.item_id
		else
			version.item_id.to_s
	end
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
