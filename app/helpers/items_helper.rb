module ItemsHelper
  def the_first_image(item)
    image = item.images.order(:position)[0]
    
    render_item_image(image) if image
  end
  
  def other_images(item)
    buffer = "".html_safe
    
    item.images.order(:position)[1..-1]&.each do |image|
      buffer << render_item_image(image)
    end
    
    buffer
  end
  
  private 
    def render_item_image(image)
      content_tag(:div) do
        image_tag image.data.variant(resize: "530x>")
      end
    end
end
