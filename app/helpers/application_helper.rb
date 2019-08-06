module ApplicationHelper
  def page_title
    title = "Carenta"
    title = @page_title + "-" + title if @page_title
    title
  end
  
  def menu_link_to(text, path, options = {})
    content_tag :li do
      link_to_unless_current(text, path, options) do
        content_tag(:span, text)
      end
    end
  end
  
  def tm(model_class, key = nil)
    if key.nil?
      model_class.model_name.human
    else
      model_class.human_attribute_name(key);
    end
  end
end
