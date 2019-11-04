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

  def order_options
    {
      '登録が新しい順' => 'A',
      '登録が古い順' => 'B',
      'ポイントが高い順' => 'C',
      'ポイントが低い順' => 'D'
    }
  end

  private 
    def render_item_image(image)
      content_tag(:div) do
        image_tag image.data.variant(resize: "530x>")
      end
    end
end
