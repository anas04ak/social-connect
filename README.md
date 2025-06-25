# Social Connect

**Social Connect** is a full-stack social media web application built with **Ruby on Rails 7**. It enables users to post updates, like and reply to content, mention other users, and interact in a modern, responsive UI.

---

## 🚀 Features

- User authentication with **Devise**
- Create, edit, and delete posts
- Comment and reply to comments (nested replies)
- Mentions with autocomplete and notifications
- Like and unlike posts and comments
- View user profiles and mentions
- Responsive design using **Bootstrap 5**
- Dynamic frontend behavior via **Stimulus JS**

---

## 🛠️ Tech Stack

| Layer          | Technology         |
|----------------|--------------------|
| Backend        | Ruby on Rails 7    |
| Frontend       | ERB + Bootstrap 5  |
| JS Framework   | Stimulus JS        |
| Authentication | Devise             |
| Database       | SQLite3 / PostgreSQL |

---

## 💻 Local Setup (Without Docker)

```bash
# Clone the repository
git clone https://github.com/anas04ak/social_connect.git
cd social_connect

# Install dependencies
bundle install
yarn install

# Set up the database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server



🐳 Docker Setup
You can also run this app entirely in Docker.

1️⃣ Build the Docker image

docker build -t social_connect .

2️⃣ Run the Rails server inside Docker

docker run -p 3000:3000 -e RAILS_ENV=development social_connect \
  ./bin/rails server -b 0.0.0.0 -p 3000

Launch the Rails console in Docker:

docker run -it --rm -e RAILS_ENV=development social_connect \
  ./bin/rails console

Make sure Redis is running and Sidekiq is started using:
bundle exec sidekiq
