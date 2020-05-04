module SimpleForm
  class PunditFormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
      policy = @options[:policy]
      if policy
        return '' unless policy.permitted_attributes.include?(attribute_name)
      end

      super
    end
  end
end
