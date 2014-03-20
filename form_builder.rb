# -*- encoding : utf-8 -*-

# Happens error message in label field name. It's an extension form builder label method.
# Usage:
#
#   <%= form_for @user, builder: InlineErrorFormBuilder do |form| %>
#     <%= form.label_with_error :email %>
#     <%= form.email_field :email %>
#     ...
#
class InlineErrorFormBuilder < ActionView::Helpers::FormBuilder
  def label(field, text = object.class.human_attribute_name(field))
    if error = object.errors[field].first
      super(field, text + ' ' + error)
    else
      super(field, text)
    end
  end
end
