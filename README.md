# Ultimate Chat Application using Elixir LiveView with TailwindCSS

Welcome to our chat application! This real-time chat system is built using Elixir LiveView, allowing users to interact seamlessly.

## Features

### 1. User Authentication

- Users can log in using a unique username.
- The application ensures a secure and personalized chat experience for each user.

### 2. Room Management

- Users have the ability to create new chat rooms.
- They can also join existing rooms to connect with others.
- Room creation and joining are simple and intuitive.
- Users can see active(online) users.

### 3. Real-Time Chat

- Users can engage in real-time conversations with other participants within a specific room.
- Messages are delivered instantly, providing a smooth and dynamic chat experience.

## Getting Started

To run the application locally, follow these steps:

### 1. Prerequisites:
   ```bash
   elixir 1.15.0-otp-26
   erlang 26.0.1
   ```

### 2. Clone the Repository:
   ```bash
   git clone git@github.com:rathorevk/ultimate_chat.git
   cd ultimate_chat
   ```
### 3. Setup
To start your Phoenix server:
-  Run `mix setup` to install and setup dependencies
-  Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.
-  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Technical Document

### 1. Authentication
- **Secure User Authentication:** The application ensures secure user authentication using unique usernames. If a username already exists, the user is redirected to their existing account; otherwise, a new user account is created.

### 2. Real-Time Communication
- **Phoenix Presence:** Utilizes Phoenix Presence for tracking active and online users in real-time. Presence functionality provides seamless updates on user status within the application.
- **Phoenix PubSub:** Implements Phoenix PubSub to facilitate the publishing and receiving of messages within the chat room. This enables real-time, asynchronous communication among users in the same room.

### 3. Message Handling
- **Pagination:** Implements message pagination to enhance performance by loading a limited number of messages initially. Users can effortlessly load more messages as needed, promoting a smoother chat experience.
- **Load More Button:** Enhances user experience with a Load More button, allowing users to retrieve additional messages without overwhelming the interface.

### 4. Navigation
- **Back Button:** Includes a back button feature for easy navigation, enabling users to return to the previous page effortlessly. This enhances the overall user experience and accessibility.
- **Logout Button:** Includes a logout button that allows users to securely log out of their accounts.
  
### 5. Input Validation
- **Unique Usernames:** Enforces the uniqueness of usernames, ensuring that each user has a distinct identity. If a username is already in use, the application directs the user to their existing account.
- **Username Format:** Restricts usernames to only allow letters, maintaining a standardized and user-friendly format.

### 6. Room Management
- **Unique Room Names**: Guarantees the uniqueness of room names, preventing duplication. Users cannot create a room with a name that already exists, ensuring a clear and organized room structure.


  
## User Interface

### 1. Login Screen:
**Screen1:**

<img width="748" alt="login" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/fe7e68fe-faf4-4ba5-80ff-1396db32d7df">

**Screen2:**

<img width="748" alt="login-2" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/e2539eaf-d527-4d47-aaa4-e288cc36d72d">


### 2. Main Screen:
**Screen1:**

<img width="748" alt="lobby-0" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/8c3108b9-5b49-4875-b2e1-9ed93320c8c9">

**Screen2:**

<img width="748" alt="lobby-1" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/f7f6829d-1ed9-4a67-9e91-f35d6d3e0533">

**Screen3:**

<img width="748" alt="create-room-1" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/e95be35e-3eed-432c-9df8-5277ec11dfa0">
<img width="748" alt="crate-room-2" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/f748b838-5e25-4da4-bc95-3a28f4069087">
<img width="748" alt="create-room-2" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/0b394252-cd32-4435-b4cb-3712b16aec66">

**Screen4:**

<img width="748" alt="join-room" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/f3bbf2c9-dd4a-49a3-9856-08f43dff3452">
<img width="748" alt="chat-00" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/631ecc73-8922-4093-84ea-af51eb732170">

### 2. Chat Screen:
<img width="748" alt="chat-3" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/66dfad25-64d2-4071-a423-03ed9a84b544">
<img width="748" alt="chat-01" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/65b8d79a-dc4d-4f16-b161-71d6680b4e3b">
<img width="748" alt="chat-1" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/15bc4c4e-ce94-4307-8439-8ff72e1c8df7">
<img width="748" alt="chat-2" src="https://github.com/rathorevk/ultimate_chat/assets/146935994/51666ed9-351a-41db-9285-b1e7d854c80f">

## Tests

To run the tests for this project, simply run in your terminal:

```shell
mix test
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix