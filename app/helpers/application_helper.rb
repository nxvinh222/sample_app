module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = t "layouts.application.title"
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def gender_lists
    I18n.t(:gender_lists).map{|key, value| [value, key]}
  end
end
