module ApplicationHelper
  def enum_t(value, key:, count: 1)
    I18n.t(value, scope: [ "activerecord.enums", key ], count: count)
  end

  def flash_colors(type)
    case type
    when 'success'
      'bg-green-50  border-green-400  text-green-700'
    when 'error'
      'bg-red-50    border-red-400    text-red-700'
    when 'warning'
      'bg-yellow-50 border-yellow-400 text-yellow-700'
    when 'notice'
      'bg-blue-50   border-blue-400   text-blue-700'
    else
      'bg-gray-50   border-gray-400   text-gray-700'
    end
  end
end
