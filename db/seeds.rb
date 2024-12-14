puts "Destroying all categories..."
Category.destroy_all

category_names = [ 'women', 'men', 'bag', 'shoes', 'watches' ]

category_names.each do |category|
  Category.create!(name: category)
end

puts "Destroying all products..."
Product.destroy_all

# Creating products with random data
10.times do
  product_name = Faker::Commerce.product_name
  price = Faker::Commerce.price(range: 10..1000)
  category_ids = Category.ids.sample(rand(1..3)) # Randomly assign 1 to 3 categories

  product = Product.create!(
    name: product_name,
    price: price,
    category_ids: category_ids
  )

  # Improved logging for better readability
  puts "#{product_name} has been created with categories: #{category_ids.join(', ')}"
end

puts "Destroying all users..."
User.destroy_all

5.times do |i|
  User.create!(
    email: "user#{i+1}@test.com",
    password: "qwerty",
    password_confirmation: "qwerty"
  )
end

puts "Destroying all favorites..."
Favorite.destroy_all

# Assigning random favorites
User.all.each do |user|
  favorited_products = Product.all.sample(rand(2..5)) # Randomly select 2 to 5 products
  user.favorited_products << favorited_products
  puts "User #{user.email} has favorited products: #{favorited_products.map(&:name).join(', ')}"
end
