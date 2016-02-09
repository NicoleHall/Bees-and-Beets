class Seed
  def self.start
    seed = Seed.new
    seed.create_customer_josh
    seed.generate_customer
    seed.create_business_admin_andrew
    # seed.generate_business_admins
    seed.create_platform_admin_jorge
    seed.generate_vendors
    seed.generate_categories
    seed.generate_items
    seed.generate_addresses
    seed.generate_orders
    seed.generate_order_items
  end

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
      password: "password",
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
      password: "password",
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
    types = ["Jams", "Produce", "Farm", "Greens",
      "Kitchen", "Winery", "Herbals", "Ranch",
      "Bakery", "Foods", "Greenhouse","Garden"]
    business_admins = User.where(role: 1)
    business_admins.each do |admin|
      kiosk = Vendor.create!(
        name: Faker::Name.name.split(" ").first + "'s " + types.sample,
        description: Faker::Lorem.paragraph,
        image_path: "https://s-media-cache-ak0.pinimg.com/236x/1e/53/94/1e53942d804bd726b332b849ca7254b0.jpg",
        status: 0,
      )
      admin.update_attributes(vendor_id: kiosk.id)
    end
  end

  def generate_categories
    10.times do |i|
      Category.create!(
        name: "Food Stuff #{i}"
      )
    end
  end

  def generate_items
    adjectives = ["delicious","delectable","golden","sweet",
                  "crispy","buttery","bitter","creamy","ripe",
                  "juicy","tart","zesty","succulent","spicy",
                  "nutty"]
    vendors = Vendor.all
    vendors.each do |vendor|
      items = []
      100.times do |i|
        vendor.items.create!(
        title: vendor.name + " " + Faker::SlackEmoji.food_and_drink.gsub(":","") + "#{i}",
        price: Faker::Commerce.price.to_i + 1,
        description: Faker::Lorem.paragraph,
        status: rand(2),
        image_path: "http://vafoodbanks.org/wp-content/uploads/2012/06/fresh_food.jpg",
        category_id: (1..10).to_a.sample
        )
      end
    end
  end

  def generate_addresses
    customers = User.where(role: 0)
    customers.each do |customer|
      customer.addresses.create!(
      label: "Home",
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zipcode: Faker::Address.zip
      )
    end
  end

  def generate_orders
    customers = User.where(role: 0)
    customers.each do |customer|
      10.times do |i|
        customer.orders.create!(
          user_id: customer.id,
          status: rand(2)
        )
      end
    end
  end

  def generate_order_items
    orders = Order.all
    orders.each do |order|
      vendors = Vendor.all
      3.times do |i|
        vendor = vendors.shuffle.pop
        order.order_items.create!(
          vendor_id: vendor.id,
          item_id: vendor.items.pluck(:id).sample,
          quantity: (1..8).to_a.sample
        )
      end
    end
  end
end

Seed.start
