# Force emails in lower case and validates format.
module DowncaseEmail
  def self.included(base)
    base.class_eval do
      validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, if: :email
    end
  end

  def email=(value)
    write_attribute(:email, value && value.downcase)
  end
end
