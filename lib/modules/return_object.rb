module ReturnObject
  def return_object(success, **params)
    Struct.new(:success?, *params.keys)
          .new(success, *params.values)
          .freeze
  end

  def return_errors(error)
    return_object(false, error: error)
  end
end
