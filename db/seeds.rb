# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Example User",
             email: "example@example.com",
             password: "foobar",
             password_confirmation: "foobar")

User.create!(name: "Example2",
              email: "example2@example.com",
              password: "abcdefg",
              password_confirmation: "abcdefg")

# Muse, Nightwish
artists = ["ef0d903f-edb3-45d9-a9d7-bf534b4be696", "00a9f935-ba93-4fc8-a33a-993abe9c936b"]
users = User.all

# create posts
num_post = 1
artists.each do |artist|
  title = Faker::Lorem.sentence(5)
  users.each do |user|
    body = Faker::Lorem.sentence(15)
    user.posts.create!(title: title, body: body, mbid: artist, url: 'posts/' + num_post.to_s)
    num_post += 1
  end
end

# create comments
posts = Post.all
num_comment = 1
posts.each do |post|
  users.each do |user|
    comment_body = Faker::Lorem.sentence(10)
    post.comments.create!(body: comment_body, user_id: user.id)
    num_comment += 1
  end
end
