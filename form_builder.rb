# -*- encoding : utf-8 -*-

# Happens error message in label field name. It's an extension form builder label method.
# Usage:
#
#   <%= form_for @user do |form| %>
#     <%= form.label_with_error :email %>
#     <%= form.email_field :email %>
#     ...
#
class ActionView::Helpers::FormBuilder
  def label_with_error(field, text = object.class.human_attribute_name(field))
    if error = object.errors[field].first
      label(field, text + ' ' + error)
    else
      label(field, text)
    end
  end
end
