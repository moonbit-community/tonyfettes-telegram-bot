///|
async fn main {
  guard @sys.get_env_var("TELEGRAM_BOT_TOKEN") is Some(token) else {
    fail("Error: TELEGRAM_BOT_TOKEN environment variable is not set")
  }
  let bot = @bot.Bot::new(token~)
  println("Echo bot started. Waiting for messages...")
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
