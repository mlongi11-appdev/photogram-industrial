task sample_data: :environment do
  p "creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all

  end

  usernames = Array.new {Faker::Name.first_name.downcase}

  usernames << "alice"
  usernames << "bob"

  10.times do |username|
    username = Faker::Name.first_name.downcase
    usernames << username 
  end

  usernames.each do |username|
    user = User.create(
      email: "#{username}@website.com",
      username: "#{username}",
      password: "password",
      private: [true, false].sample
    )
    p user.errors.full_messages
  end

  users = User.all
  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample
        )
      end
    end
  end

  users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::TvShows::DumbAndDumber.quote,
        image: "https://robohash.org/#{rand(9999)}"
      )

      user.followers.each do |follower|
        if rand < 0.5
          photo.fans << follower
        end

        if rand < 0.25
          photo.comments.create(
            body: Faker::TvShows::Friends.quote,
            author: follower
          )
        end
      end
    end
  end
  p "#{User.count} users have been created."
  p "#{FollowRequest.count} follow requests have been created."
  p "#{Photo.count} photos have been created."
  p "#{Comment.count} comments have been created."
  p "#{Like.count} likes have been created."



end