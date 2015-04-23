class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true

  def display
    if title.empty? && content.empty?
      ''
    elsif !title.empty? && content.empty?
      title
    elsif title.empty? && content.empty?
      content
    else
      title + ' - ' + content
    end
  end
end
