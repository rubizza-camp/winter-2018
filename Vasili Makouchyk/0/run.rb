require_relative 'menu.rb'
loop do
  menu = Menu.new

  user_input = menu.ask_for_input

  return if user_input.casecmp('EXIT').zero?

  products = menu.find_product_in_current_file(user_input)

  next if products.empty?

  product = menu.choose_product_to_show(products)

  product_array = menu.find_product_in_previous_files(product)

  max_min_price = menu.find_max_min_price_at_date(product_array)

  menu.view_products_found(
    product_array,
    max_min_price,
    menu.find_products_with_same_price(product_array[0][1])
  )
end
