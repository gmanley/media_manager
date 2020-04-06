module SimpleForm
  class PunditFormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
      policy = options.delete(:policy)
      if policy
        return '' unless policy.permitted_attributes.include?(attribute_name)
      end

      super(attribute_name, options.merge(label: false), &block)
    end
  end
end
