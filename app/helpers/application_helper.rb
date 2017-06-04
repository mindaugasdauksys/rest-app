# main helper
module ApplicationHelper
  def view_object(name, args)
    if name.is_a?(Symbol)
      class_name = name.to_s.titleize.split(' ').join('')
    else
      class_name = name.split('/').map { |title| title.titleize.sub(' ', '') }
                       .join('::')
    end
    class_name.constantize.new(args)
  end
end
