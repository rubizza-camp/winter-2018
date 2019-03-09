module ApplicationHelper
  def body_class(class_name="default_class")
    content_for :body_class, class_name
  end
end
