# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoonBit Telegram Bot API library (`tonyfettes/telegram-bot`). Provides typed async wrappers around the Telegram Bot HTTP API. This is the `bot/` package extracted from the upstream [moonbit-telegram](https://github.com/moonbit-community/tonyfettes-moonbit-telegram) monorepo as a standalone library.

## Commands

```bash
moon check                              # Type check
moon fmt                                # Format code
moon test                               # Run all tests
moon test -f "User JSON"                # Run tests matching name pattern
moon info                               # Generate .mbti interface files
```

Preferred target is `native`. Integration tests (`integration_test.mbt`) only compile for native target.

## Commit Style

- Format: `<type>(<scope>): <description>` with body explaining what and why
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- Always include `Co-Authored-By` trailer

## Architecture

Single flat package — all `.mbt` files live at the project root. No subdirectories.

### Core Components

- **`bot.mbt`** — `Bot` struct, `parse_api_response()` helper, and ~106 async API methods. Each method builds a JSON request body, POSTs to `{base_url}/bot{token}/{methodName}`, and deserializes the response.
- **`error.mbt`** — `TelegramError` suberror type covering HTTP, API, UTF-8, JSON, and parse failures.
- **Type files** (`user.mbt`, `chat.mbt`, `message.mbt`, etc.) — One Telegram API type per file with struct definition, `Type::new()` constructor, and custom `ToJson`/`FromJson` implementations.
- **Test files** (`*_test.mbt`) — Paired 1:1 with source files. Unit tests use JSON round-trip pattern. Integration tests in `integration_test.mbt` use HTTP mock servers with `@async.with_task_group`.

### Dependencies

- `moonbitlang/async` — Async runtime, HTTP client/server, I/O
- `tonyfettes/json` — JSON parsing/serialization with `ToJson`/`FromJson` traits

## Code Patterns

### Type definitions

Each type file follows: struct with `derive(Show, Eq)` → `Type::new()` constructor → custom `ToJson` → custom `FromJson`.

```moonbit
pub struct Type {
  required : T
  optional : T?          // Option type for nullable fields
} derive(Show, Eq)

pub fn Type::new(required~ : T, optional? : T) -> Type {
  { required, optional }
}
```

- `~` = required named parameter, `?` = optional named parameter
- Reserved words escaped: `type_` field maps to `"type"` in JSON
- Single-field struct constructors need trailing comma: `{ field, }` to avoid ambiguous block warning

### JSON serialization

```moonbit
pub impl @json.ToJson for Type with to_json(self) {
  let object : Map[String, Json] = { "required": @json.to_json(self.required) }
  if self.optional is Some(v) { object["optional"] = @json.to_json(v) }
  @json.to_json(object)
}

pub impl @json.FromJson for Type with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Type")
  }
  let required : T = @json.from_json(object["required"], path~)
  let optional : T? = if object.get("optional") is Some(v) {
    Some(@json.from_json(v, path~))
  } else { None }
  { required, optional }
}
```

### API methods

```moonbit
pub async fn Bot::method_name(self : Bot, required~ : T, optional? : T,
) -> ReturnType raise TelegramError {
  let url = self.api_url("methodName")
  let body : Map[String, Json] = { "required": @json.to_json(required) }
  if optional is Some(v) { body["optional"] = @json.to_json(v) }
  // HTTP POST, guard 200-299, parse_api_response(data)
}
```

### Tests

Unit tests use JSON round-trip:
```moonbit
test "Type JSON round-trip" {
  let obj = Type::new(field=value)
  let parsed : Type = @json.from_json(@json.to_json(obj))
  inspect(parsed.field, content="expected")
}
```

Integration tests mock an HTTP server and test `Bot` methods end-to-end.
