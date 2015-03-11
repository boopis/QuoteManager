Warden::Manager.after_set_user do |user, auth, opts|
  directory = Foldersize.define_folder("#{Rails.root}/uploads/files/#{user.account.id}")
  usage = directory.size_in_bytes
  user.account.update(storage_usage: usage)
end