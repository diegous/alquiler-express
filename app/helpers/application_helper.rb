module ApplicationHelper
  def enum_t(value, key:, count: 1)
    I18n.t(value, scope: [ "activerecord.enums", key ], count: count)
  end
end
