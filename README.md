# telegram-bot

MoonBit Telegram Bot API library with async support.

## Installation

```bash
moon add tonyfettes/telegram-bot
```

## Quick Start

```moonbit
async fn main {
  guard @sys.get_env_var("TELEGRAM_BOT_TOKEN") is Some(token) else {
    fail("Error: TELEGRAM_BOT_TOKEN environment variable is not set")
  }
  let bot = @bot.Bot::new(token~)
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~, timeout=30) catch {
      error => {
        println("Error getting updates: \{error}")
        continue
      }
    }
    for update in updates {
      offset = update.update_id + 1
      if update.message is Some(msg) && msg.text is Some(text) {
        try bot.send_message(chat_id=msg.chat.id, text~) |> ignore() catch {
          error => println("Error sending message: \{error}")
        }
      }
    }
  }
}
```

## Features

- 106 async API methods covering the Telegram Bot API
- Typed structs for all Telegram types (users, chats, messages, media, inline queries, payments, etc.)
- JSON serialization/deserialization for all types
- Structured error handling via `TelegramError`

## API Overview

The library wraps Telegram Bot API methods as async functions on the `Bot` struct. Each method accepts named parameters and returns typed results.

```moonbit
// Send a text message
bot.send_message(chat_id=123456L, text="Hello!") |> ignore()

// Send a photo
bot.send_photo(chat_id=123456L, photo="https://example.com/photo.jpg") |> ignore()

// Get bot info
let me = bot.get_me()

// Edit a message
bot.edit_message_text(chat_id=123456L, message_id=42, text="Updated!") |> ignore()
```

Methods are organized into groups: messages, media, chat management, inline queries, payments, stickers, forum topics, games, and more.

## Error Handling

All API methods raise `TelegramError`, which covers:

- `HttpError` -- HTTP request failures
- `ApiError` -- Telegram API errors (invalid token, permission denied, etc.)
- `InvalidUtf8` / `InvalidJson` -- Response decoding failures
- `InvalidResponse` / `InvalidResult` -- Unexpected response structure
- `ParseError` -- Generic parsing errors

## License

Apache-2.0
