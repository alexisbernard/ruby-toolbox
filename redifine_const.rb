# -*- encoding : utf-8 -*-

class Module

  # Sets the named constant to the given object, returning that object.
  def redefine_const(sym, obj)
    remove_const(sym)
    const_set(sym, obj)
  end

end
