///|
fn main {
  let token = match @sys.get_env_var("TELEGRAM_BOT_TOKEN") {
    Some(t) => t
    None => {
      println("Error: TELEGRAM_BOT_TOKEN environment variable is not set")
      @sys.exit(1)
      panic()
    }
  }
  let bot = @bot.Bot::new(token~)
  println("Echo bot started. Waiting for messages...")
  @async.run_async_main(
    async fn() {
      let mut offset = 0
      while true {
        let updates = try {
          bot.get_updates(offset~, timeout=30)
        } catch {
          _ => {
            println("Error getting updates")
            continue
          }
        }
        for update in updates {
          offset = update.update_id + 1
          if update.message is Some(msg) && msg.text is Some(text) {
            try {
              let _ = bot.send_message(chat_id=msg.chat.id, text~)

            } catch {
              _ => println("Error sending message")
            }
          }
        }
      }
    },
  )
}
