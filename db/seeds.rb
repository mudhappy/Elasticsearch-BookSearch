# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
6.times do
  Author.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end

6.times do
  BookCategory.create(title: Faker::Book.genre)
end

20.times do
  Book.create(
    name: Faker::Book.title,
    description: "
      #{Faker::SiliconValley.quote}
      #{Faker::SiliconValley.quote}
      #{Faker::SiliconValley.quote}
      #{Faker::SiliconValley.quote}
      #{Faker::SiliconValley.quote}
      #{Faker::SiliconValley.quote}",
    isbn: Faker::Lorem.characters(8).upcase,
    pages: Faker::Number.between(10, 400),
    book_category_id: Faker::Number.between(1, 6),
    author_id: Faker::Number.between(1, 6),
    published_at: Faker::Date.between(4.years.ago, Date.today)
  )
end
