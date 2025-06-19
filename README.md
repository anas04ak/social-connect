# Social Connect

**Social Connect** is a full-stack social media web application built with **Ruby on Rails 7**. It enables users to post updates, like and reply to content, mention other users, and interact in a modern, responsive UI.

## 🚀 Features

- User authentication with **Devise**
- Create, edit, and delete posts
- Comment and reply to comments (nested replies)
- Mentions with autocomplete and notifications
- Like and unlike posts and comments
- View user profiles and mentions
- Responsive design using **Bootstrap 5**
- Dynamic frontend behavior via **Stimulus JS**

## 🛠️ Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Backend      | Ruby on Rails 7    |
| Frontend     | ERB + Bootstrap 5  |
| JS Framework | Stimulus JS        |
| Authentication | Devise          |
| Database     | SQLite3 / PostgreSQL |

## 💻 Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/anas04ak/social_connect.git
cd social_connect

bundle install
yarn install 

rails db:create
rails db:migrate
rails db:seed  

rails server

