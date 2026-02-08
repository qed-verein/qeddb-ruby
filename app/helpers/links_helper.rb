module LinksHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Dieses Hilfsmodul definiert automatisch Links für standardmäßige CRUD-Operation
  # bei Personen, Veranstaltungen. Diese werden nur angezeigt, wenn die Rechte vorliegen
  module ClassMethods
    def default_crud_links(name, options = {})
      operations = %i[index new show edit destroy]
      operations &= options[:only] if options.key? :only
      operations -= options[:except] if options.key? :except

      name = name.downcase.to_s

      if operations.include? :index
        define_method("#{name.pluralize}_link") do
          klass = name.classify.constantize
          return unless policy(name.classify.constantize).index?

          link_to klass.model_name.human(count: :other), send("#{name.pluralize}_path")
        end
      end

      if operations.include? :new
        define_method("new_#{name}_link") do
          return unless policy(name.classify.constantize).new?

          icon_button t("actions.#{name}.new"), :add, send("new_#{name}_path")
        end
      end

      if operations.include? :show
        define_method("#{name}_link") do |object|
          return object.title unless policy(object).show?

          link_to object.title, object
        end
      end

      if operations.include? :edit
        define_method("edit_#{name}_link") do |object|
          return unless policy(object).edit?

          icon_button t("actions.#{name}.edit"), :edit, send("edit_#{name}_path", object)
        end
      end

      return unless operations.include? :destroy

      define_method("delete_#{name}_link") do |object|
        return unless policy(object).destroy?

        link_to object, class: 'button', method: :delete,
                        data: { confirm: t("actions.#{name}.delete_confirm", title: object.title) } do
          concat mi.shape(:delete).md_24
          concat t("actions.#{name}.delete")
        end
      end
    end
  end
end
