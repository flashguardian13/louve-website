class BBCodeValidator < ActiveModel::Validator
  def validate_bbcode(model, property)
    if model[property].is_a?(String)
      errors = model[property].bbcode_check_validity
      if errors.is_a?(Array) && !errors.empty?
        model.errors[property].concat(errors)
      end
    else
      model.errors[property] << "#{property.to_s.capitalize} cannot be anything other than text."
    end
  end
end

