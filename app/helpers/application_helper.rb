require 'simple_form/pundit_form_builder'

# encoding: UTF-8
module ApplicationHelper
  BOOTSTRAP_FLASH_CLASS = {
    alert:   'warning',
    notice:  'info',
  }

  def bootstrap_flash_class(type)
    BOOTSTRAP_FLASH_CLASS.fetch(type.to_sym, type.to_s)
  end

  def flash_messages
    flash.each do |type, message|
      flash_message(type, message) if message.is_a?(String)
    end
  end

  def build_nav_item(url:, text:)
    html_class = 'nav-item'
    html_class << ' active' if current_page?(url)
    haml_tag :li, class: html_class do
      haml_tag :a, class: 'nav-link', href: url do
        haml_concat text
        haml_tag :span, class: 'sr-only' do
          'Current'
        end
      end
    end
  end

  def simple_form_with_policy_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: SimpleForm::PunditFormBuilder)), &block)
  end

  private

  def flash_message(type, message)
    haml_tag :div, class: "alert alert-#{bootstrap_flash_class(type)} fade show" do
      haml_tag 'a.close', '×', data: { dismiss: 'alert' }
      haml_concat(message)
    end
  end
end
