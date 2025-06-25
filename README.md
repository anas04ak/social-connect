# 🌐 Social Connect

**Social Connect** is a full-stack social media web application built with **Ruby on Rails 7.1.5.1** and **Ruby 3.0.0**. It enables users to post updates, like and reply to content, mention other users, and interact in a modern, responsive UI. The app also features **Instagram integration**, allowing users to connect their profiles and import their posts automatically.

---

## 🚀 Features

- 🔐 User authentication with **Devise**
- 📝 Create, edit, and delete posts
- 💬 Comment and reply to comments (multi-level nesting)
- 💡 Mentions with **autocomplete** and **notifications**
- ❤️ Like and unlike **posts** and **comments**
- 👥 View user profiles and profile pictures
- 🌈 Responsive design using **Bootstrap 5.3.3**
- ⚡ Dynamic frontend behavior via **Stimulus JS**
- 📸 **Instagram Connect**:
  - Scrapes latest 9 Instagram post images on profile connection
  - Automatically imports them as posts into the app
  - Extracts the Instagram username and sets it as the app username
  - Background scraping handled via **Sidekiq + Redis**

---

## 🛠️ Tech Stack

| Layer           | Technology          |
|-----------------|---------------------|
| Backend         | Ruby on Rails 7.1.5.1 |
| Ruby Version    | 3.0.0               |
| Frontend        | ERB + Bootstrap 5.3.3   |
| JS Framework    | Stimulus JS         |
| Authentication  | Devise              |
| Database        | SQLite3 (development) |
| Background Jobs | Sidekiq + Redis     |

---

## 💻 Local Setup (Without Docker)

```bash
# Clone the repository
git clone https://github.com/anas04ak/social_connect.git
cd social_connect

# Install dependencies
bundle install

# Set up the database
rails db:create
rails db:migrate

# Start the Rails server
rails server

🔁 Redis & Sidekiq Setup
📥 Install Redis (macOS/Linux/WSL)

# macOS (with Homebrew)
brew install redis

# Ubuntu / Debian
sudo apt update
sudo apt install redis-server

# Start Redis
redis-server

▶️ Run Sidekiq

In a separate terminal, inside your project directory:
bundle exec sidekiq

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
