module ContactsHelper
  def split_name(name, location)
    if name.index(" ")
      name = name.split(' ')[location]
    else
      name = "n/a"
    end
    return name
  end
end
