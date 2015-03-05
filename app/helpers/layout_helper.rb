module LayoutHelper
  def flash_messages(opts={})
    @layout_flash = opts.fetch(:layout_flash) { true }

    capture do
      flash.each do |name, msg|
        concat content_tag(:div, msg, id: "flash_#{name}")
      end
    end
  end

  def admin_messages
    capture do
      flash.each do |name, msg|

        name = name.to_sym
        name = :success if name == :notice
        name = :error   if name == :alert

        concat content_tag(:div, 
                           content_tag(:button, raw("&times;"), class: "close", data: {dismiss: "alert"}) +
                           content_tag(:i, "", class: "fa fa-#{name == :success ? "check-circle" : "warning"} fa-fw fa-lg") +
                           msg.html_safe, 
                           class: "alert alert-#{name} fade in")
      end
    end
  end

  def show_layout_flash?
    @layout_flash.nil ? true : @layout_flash
  end

  def sidebar_nav(link_path, link_text, link_icon)
    li_class = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: li_class) do
      link_to link_path do
        content_tag(:i, "", class: link_icon) +
        content_tag(:span, link_text)
      end
    end
  end

  def submenu_nav(link_path, link_text, link_icon, controller, submenu={})
    li_class = params[:controller] == controller ? 'active' : ''

    content_tag(:li, class: li_class) do
      content = link_to link_path, class: 'dropdown-toggle' do
        content_tag(:i, "", class: link_icon) +
        content_tag(:span, link_text) +
        content_tag(:i, "", class: "fa fa-chevron-circle-down drop-icon")
      end
      content += content_tag(:ul, class: 'submenu') do
        submenu.each do |k, v|
          a_class = current_page?(v) ? 'active' : ''
          concat content_tag(:li, (link_to k, v, class: a_class))
        end
      end
    end
  end
end
