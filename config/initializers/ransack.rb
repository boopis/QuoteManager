Ransack::Helpers::FormHelper.module_eval do
  def link_name(label_text, dir)
    ERB::Util.h(label_text).html_safe
  end
end