# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def t_boolean(b)
    t(b.to_s.to_sym)
  end
end
