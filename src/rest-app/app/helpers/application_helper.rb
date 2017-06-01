# main helper
module ApplicationHelper
  def table_object(name, args = {})
    class_name = if name.is_a?(Symbol)
                   name.to_s.titleize.split(' ').join('')
                 else
                   name.split('/').map do |n|
                     n.titleize.sub(' ', '')
                   end.join('::')
                 end
    class_name.constantize.new(self, args)
  end
end
