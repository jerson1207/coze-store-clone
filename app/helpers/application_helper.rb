module ApplicationHelper
  def modal_button(text, product, options = {})
    # Set the default class to your provided structure
    options[:class] = "absolute bottom-5 left-1/2 transform -translate-x-1/2 translate-y-10 opacity-0 bg-white hover:bg-black hover:text-[#ddd] text-gray-500 px-4 py-2 rounded-2xl transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100"

    # Ensure the data-action is set to trigger the Stimulus modal controller open method
    options[:data] ||= {}
    options[:data][:action] = "click->modal#open"
    options[:data][:product_id] = product.id
    options[:data][:product_name] = product.name
    options[:data][:controller] = "modal"

    # Create and return the button with the provided text and options
    button_tag(text, options)
  end
end
