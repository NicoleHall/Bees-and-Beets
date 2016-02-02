class Seed

  def create_customer_josh
    User.create!(
    first_name: "Josh",
    last_name: "Mejia",
    username: "josh@turing.io",
    email_address: "josh@turing.io",
    password: "password",
    role: 0
    )
  end

  def generate_customer
    99.times do |i|
      name = Faker::Name.name.split(" ")
      User.create!(
      first_name: name.first,
      last_name: name.last,
      username: name.join(".").downcase,
      email_address: Faker::Internet.email,
      password: "password"
      role: 0
      )
    end
  end

  def create_business_admin_andrew
    User.create!(
    first_name: "Andrew",
    last_name: "Carmer",
    username: "andrew@turing.io",
    email_address: "andrew@turing.io",
    password: "password",
    role: 1
    )
  end

  def generate_business_admins
    19.times do |i|
      name = Faker::Name.name.split(" ")
      User.create!(
      first_name: name.first,
      last_name: name.last,
      username: name.join(".").downcase,
      email_address: Faker::Internet.email,
      password: "password"
      role: 1
      )
    end
  end


  def create_platform_admin_jorge
    User.create!(
    first_name: "Jorge",
    last_name: "Bieber",
    username: "jorge@turing.io",
    email_address: "jorge@turing.io",
    password: "password",
    role: 2
    )
  end

  def generate_vendors
    business_admins = User.where(role: 1)
    business_admins.each do |admin|
      vendor = Vendor.create!(
      name: Faker::Company.name,
      description: Faker::Lorem.paragraph,
      image_path: Faker::Company.logo,
      user_id: admin.id
      )
    end
  end

  def generate_items
    vendors = Vendor.all
    vendors.each do |vendor|
      items = []
      100.times do |i|
        items << Item.create!(
        title: Faker::SlackEmoji.food_and_drink.gsub(":",""),
        price: Faker::Commerce.price,
        description: Faker::Hipster.paragraph,
        status: rand(2),
        image_path: "http://lorempixel.com/600/600/food"
        )
      end
      vendor.items << items
    end
  end

  def generate_addresses
    customers = User.where(role: 0)
    customers.each do |customer|
      customer.address.create!(
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zipcode: Faker::Address.zip
      )
    end
  end

  def generate_orders
    customers = User.where(role: 0)
    vendors = Vendor.take(20)
    customers.each do |customer|
      10.times do |i|
        customer.orders.create!(
          address_id: customer.address,
          user_id: customer.id,
          status: rand(4),
          vendor_id: vendors.sample.id
        )
      end
    end
  end

  def generate_order_items
    orders = Order.all
    orders.each do |order|
      item_ids = order.vendor.items.pluck(:id)
      3.times do |i|
        order.order_items.create!(
          item_id: item_ids.sample,
          quantity: rand(8)
        )
      end
    end
  end
end











# class Seed
#   def self.start
#     new.generate
#   end
#
#   def generate
#     create_categories
#     create_artists
#     create_items
#     create_users
#   end
#
#   def create_categories
#     categories = %w(Painting Digital Photography)
#
#     categories.each do |name|
#       Category.create!(name: name)
#     end
#
#     @painting = Category.find_by(name: categories[0])
#     @digital = Category.find_by(name: categories[1])
#     @photography = Category.find_by(name: categories[2])
#   end
#
#   def create_artists
#     artists = ["Brenna Martenson",
#                "Taylor Moore",
#                "Toni Rib"]
#
#     artists.each do |full_name|
#       first_name = full_name.split.first
#       last_name = full_name.split.last
#
#       User.create!(first_name: first_name,
#                    last_name: last_name,
#                    username: "#{first_name.downcase}_artist",
#                    password: "password",
#                    role: 1,
#                    email_address: "#{first_name.downcase}_artist@gmail.com",
#                    street_address: "123 Maple Drive",
#                    city: "Denver",
#                    state: "CO",
#                    zipcode: 80231)
#     end
#
#     @brenna = User.find_by(first_name: "Brenna")
#     @taylor = User.find_by(first_name: "Taylor")
#     @toni = User.find_by(first_name: "Toni")
#   end
#
#   def create_items
#     Item.create!(title: "Paris",
#                  description: "Oil painting of Paris and the Eiffel Tower",
#                  price: 200,
#                  image_path: "http://tinyurl.com/zs8xlz8",
#                  user_id: @brenna.id,
#                  category_id: @painting.id)
#     Item.create!(title: "German Castle",
#                  description: "Photograph of an awe inspiring German castle",
#                  price: 100,
#                  image_path: "http://tinyurl.com/h7qo2n2",
#                  user_id: @brenna.id,
#                  category_id: @photography.id)
#     Item.create!(title: "Shanghai Landscape",
#                  description: "Photograph of the TV Tower in Shanghai",
#                  price: 80,
#                  image_path: "http://tinyurl.com/hwkg2a4",
#                  user_id: @brenna.id,
#                  category_id: @photography.id)
#     Item.create!(title: "Aurora Borealis",
#                  description: "Photograph of the Aurora Borealis in winter",
#                  price: 150,
#                  image_path: "http://tinyurl.com/zccbtyz",
#                  user_id: @brenna.id,
#                  category_id: @photography.id)
#     Item.create!(title: "Sailboat in Fall",
#                  description: "Acrylic painting of a colorful sailboat",
#                  price: 200,
#                  image_path: "http://tinyurl.com/zo5d93t",
#                  user_id: @toni.id,
#                  category_id: @painting.id)
#     Item.create!(title: "Colorful Trees",
#                  description: "Digital image of amazing colorful trees",
#                  price: 60,
#                  image_path: "http://tinyurl.com/z2457zf",
#                  user_id: @toni.id,
#                  category_id: @digital.id)
#     Item.create!(title: "Flower Girl",
#                  description: "Digital art of a woman with a flowering face",
#                  price: 150,
#                  image_path: "http://tinyurl.com/h9nvajo",
#                  user_id: @toni.id,
#                  category_id: @digital.id)
#     Item.create!(title: "Darkness",
#                  description: "Painting of the dark knight",
#                  price: 300,
#                  image_path: "http://tinyurl.com/gtckjgl",
#                  user_id: @taylor.id,
#                  category_id: @painting.id)
#     Item.create!(title: "Aspens in the Fall",
#                  description: "Amazing photograph of aspens",
#                  price: 100,
#                  image_path: "http://tinyurl.com/jk2t3p3",
#                  user_id: @taylor.id,
#                  category_id: @photography.id)
#     Item.create!(title: "The Batman Watches",
#                  description: "Digital image of Batman watching" \
#                               " over the city of Gotham",
#                  price: 125,
#                  image_path: "http://tinyurl.com/h7dtwv4",
#                  user_id: @taylor.id,
#                  category_id: @digital.id)
#     Item.create!(title: "Cheers!",
#                  description: "Digital image of delicious cold beer",
#                  price: 30,
#                  image_path: "http://tinyurl.com/hnfhnt9",
#                  user_id: @taylor.id,
#                  category_id: @digital.id)
#   end
#
#   def create_users
#     artists = ["Brenna Martenson",
#                "Taylor Moore",
#                "Toni Rib"]
#
#     artists.each do |full_name|
#       first_name = full_name.split.first
#       last_name = full_name.split.last
#
#       User.create!(first_name: first_name,
#                    last_name: last_name,
#                    username: "#{first_name.downcase}_user",
#                    password: "password",
#                    role: 0,
#                    email_address: "#{first_name.downcase}_user@gmail.com",
#                    street_address: "123 Maple Drive",
#                    city: "Denver",
#                    state: "CO",
#                    zipcode: 80231)
#     end
#   end
# end
#
# Seed.start
