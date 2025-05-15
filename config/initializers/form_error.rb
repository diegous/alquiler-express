ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')

  html = if field
           field['class'] = "#{field['class']} invalid"
           html = <<-HTML
              <div class="form-error-field">#{fragment.to_s}</div>
              <p class="form-error-message">#{instance_tag.error_message.first}</p>
           HTML
           html
         else
           html_tag
         end

  html.html_safe
end
