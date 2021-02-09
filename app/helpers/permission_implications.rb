# A small mixin for handling permission dependencies
module PermissionImplications
	def self.included(base)
		base.extend ClassMethods
	end
	
	# Grants additional permissions with all implications
	def grant(permission)
		@granted ||= []
		@granted |= implied_permissions(permission)
	end

	# Grants all possible permissions
	def grant_all
		@granted = all_permissions
	end
	
	# List all granted permissions
	def granted_list
		@granted.nil? ? [] : @granted
	end
	
	module ClassMethods
		# Defines the implication graph and constructs query functions 
		# for all permissions by monkey-patching
		def define_implications(implications)
			@implications ||= {}
			@implications.merge!(implications) {|k,v1,v2| v1 | v2}
			transitive = transitive_hull(@implications)
			transitive.each_key do |key|
				define_method(key.to_s + '?') {granted_list.include?(key)}
			end

			define_method('implied_permissions') {|initial|
				transitive.has_key?(initial) ? transitive[initial] : []}
	
			define_method('all_permissions') {transitive.keys.sort}
		end
			
		private
		
		# Computes a transitive hull for the implication graph
		def transitive_hull(implications)
		  transitive = {}
		  keys = implications.keys | implications.values.flatten
		  keys.each do |key|
		    weaker = []
		    queue = [key]
		    until queue.empty?
		      weaker |= queue
		      queue = queue.map{|k| implications[k]}.compact.flatten - weaker
		    end
		    transitive[key] = weaker.sort
		  end
		  transitive
		end
	end
end
