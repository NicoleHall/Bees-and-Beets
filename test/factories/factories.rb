FactoryGirl.define do
  factory :item do
    price
    description "This is food"
    title
    image_path "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTmmnVDNMRzWNavHqRRaaHMyY_e4_qg5QsoBIGxRNhuhJmNdRUO"
    association :vendor, factory: :vendor
    category
  end

  factory :category do
    name
    factory :category_with_items do
      transient do
        item_count 2
      end

      after(:create) do |category, evaluator|
        create_list(:item, evaluator.item_count, category: category)
      end
    end
  end

  factory :user do
    first_name
    last_name
    username
    password "password"
    email_address

    factory :user_with_orders do
      transient do
        order_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:order, evaluator.order_count, user: user)
      end
    end
  end

  factory :vendor do
    status 0
    name { generate(:vendor_name) }
    description "A shop."
    image_path "http://theveganherald.com/wp-content/uploads/2015/12/Farm-Animals.jpg"
    factory :vendor_with_items do
      transient do
        item_count 2
      end

      after(:create) do |vendor, evaluator|
        create_list(:item, evaluator.item_count, vendor: vendor)
      end
    end
  end

  factory :order_item do
    order
    item
    quantity 1
  end

  factory :order do
    user
    status
  end

  sequence :vendor_name do |n|
    "vendor_#{n}"
  end

  sequence :status, %w(ordered paid cancelled completed).cycle do |n|
    n
  end

  sequence :name, %w(a b c d e f g h i).cycle do |n|
    "name#{n}"
  end

  sequence :email_address do |n|
    "example#{n}@gmail.com"
  end

  sequence :first_name do |n|
    "firstname#{n}"
  end

  sequence :last_name do |n|
    "lastname#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  sequence :price do |n|
    0 + n
  end

  sequence :username do |n|
    "username#{n}"
  end
end
