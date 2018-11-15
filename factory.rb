require "factory_bot"
include FactoryBot::Syntax::Methods

FactoryBot.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    admin false
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    admin      true
  end
end

user = build(:user)
puts user.first_name