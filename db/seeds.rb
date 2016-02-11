class Seed

  def self.start
    seed = Seed.new
    seed.create_customer_josh
    seed.generate_customer
    seed.create_business_admin_andrew
    seed.generate_business_admins
    seed.create_platform_admin_jorge
    seed.generate_vendors
    seed.generate_categories
    seed.generate_items
    seed.generate_orders
    seed.generate_order_items
    seed.populate_mikes_store
    seed.populate_rachels_store
    seed.generate_future_collaborator
  end

  def populate_mikes_store
    mike = User.create!(
    first_name: "Mike",
    last_name: "Dao",
    username: "mike@turing.io",
    email_address: "mike@turing.io",
    password: "password",
    role: 1
    )

    kiosk = Vendor.create!(
    name: "Mike's Kiosk",
    description: "I sell all the best goods",
    image_path: "http://cdn.honestlywtf.com/wp-content/uploads/2011/01/storefront5.jpg",
    status: 1
    )
    mike.update_attributes(vendor_id: kiosk.id)
    kiosk.update_attributes(owner_id: mike.id)

    goods = Category.create(name: "Hosiery")
    ties = Category.create(name: "Ties")

    kiosk.items.create!(
    title: "Tube Socks",
    price: 9,
    description: "Show off those sassy legs",
    status: 1,
    image_path: "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=19993432",
    category_id: goods.id
    )

    kiosk.items.create!(
    title: "Stockings",
    price: 18,
    description: "Lovely patterns",
    status: 1,
    image_path: "http://www.fashionwindows.net/images/2009/03/dkny_tights.jpg",
    category_id: goods.id
    )

    kiosk.items.create!(
    title: "Bow Tie",
    price: 85,
    description: "You'll like the way you look, I guarantee it",
    status: 1,
    image_path: "http://www.laurentdesgrange.com/bowties/designup03.jpg",
    category_id: ties.id
    )

    kiosk.items.create!(
    title: "Neck Tie",
    price: 60,
    description: "Look sharp!",
    status: 1,
    image_path: "http://dougandgenemeyer.com/images/665.jpg",
    category_id: ties.id
    )
  end

  def populate_rachels_store
    rachel = User.create!(
    first_name: "Rachel",
    last_name: "Warbelow",
    username: "rachel@turing.io",
    email_address: "rachel@turing.io",
    password: "password",
    role: 1
    )

    kiosk = Vendor.create!(
    name: "Rachel's Kiosk",
    description: "I sell all the cutest pets",
    image_path: "http://www.pawsleecounty.com/assets/KGrHqNHJBcE63VgzhjZBO58250-g60_35.jpg",
    status: 1
    )
    rachel.update_attributes(vendor_id: kiosk.id)
    kiosk.update_attributes(owner_id: rachel.id)

    puppies = Category.create(name: "Puppies")
    piglets = Category.create(name: "Piglets")

    kiosk.items.create!(
    title: "Piglet",
    price: 50,
    description: "This little guy loves to snuggle",
    status: 1,
    image_path: "http://justcuteanimals.com/wp-content/uploads/2014/09/cute-piglet-animal-pictures-pigs-piggies-pics.jpg",
    category_id: piglets.id
    )

    kiosk.items.create!(
    title: "Piglet in Rainboots",
    price: 60,
    description: "Puddles won't stop this piglet!",
    status: 1,
    image_path: "http://www.lovethispic.com/uploaded_images/19733-Piglet-In-A-Puddle.jpg",
    category_id: piglets.id
    )

    kiosk.items.create!(
    title: "Tiny Puppy",
    price: 100,
    description: "Miniture Golden Retriever",
    status: 1,
    image_path: "http://www.lifewithdogs.tv/wp-content/uploads/2015/05/5.16.15-Cutest-Sleeping-Puppies5.jpg ",
    category_id: puppies.id
    )

    kiosk.items.create!(
    title: "Lab Retriever Mix Puppy",
    price: 110,
    description: "Promises to give you puppy kisses",
    status: 1,
    image_path: "http://cdn.sheknows.com/articles/2013/04/Puppy_2.jpg ",
    category_id: puppies.id
    )
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
      email = Faker::Internet.email
      User.create!(
      first_name: name.first,
      last_name: name.last,
      username: email,
      email_address: email,
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
        name: Faker::Name.name.split(" ")[-2] + "'s " + types.sample,
        description: Faker::Lorem.paragraph,
        image_path: "https://s-media-cache-ak0.pinimg.com/236x/1e/53/94/1e53942d804bd726b332b849ca7254b0.jpg",
        status: rand(3),
        )
        admin.update_attributes(vendor_id: kiosk.id)
        kiosk.update_attributes(owner_id: admin.id)
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
            quantity: (1..8).to_a.sample,
            status: rand(3)
            )
          end
        end
      end

      def generate_future_collaborator
        jeff = User.create!(
        first_name: "Jeff",
        last_name: "Casimir",
        username: "jeff@turing.io",
        email_address: "jeff@turing.io",
        password: "password",
        role: 1
        )
      end
    end


    Seed.start
