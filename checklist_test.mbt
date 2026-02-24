///|
test "ChecklistTask JSON round-trip" {
  let object = ChecklistTask::new(id=1, text="Task 1", is_done=false)
  let json = @json.to_json(object)
  let parsed : ChecklistTask = @json.from_json(json)
  inspect(parsed.id, content="1")
  inspect(parsed.text, content="Task 1")
  inspect(parsed.is_done, content="false")
}

///|
test "Checklist JSON round-trip" {
  let task1 = ChecklistTask::new(id=1, text="Task 1", is_done=true)
  let task2 = ChecklistTask::new(id=2, text="Task 2", is_done=false)
  let object = Checklist::new(header="Shopping List", tasks=[task1, task2])
  let json = @json.to_json(object)
  let parsed : Checklist = @json.from_json(json)
  inspect(parsed.header, content="Shopping List")
  inspect(parsed.tasks.length(), content="2")
  inspect(parsed.tasks[0].text, content="Task 1")
  inspect(parsed.tasks[0].is_done, content="true")
  inspect(parsed.tasks[1].text, content="Task 2")
  inspect(parsed.tasks[1].is_done, content="false")
}

///|
test "InputChecklistTask JSON round-trip" {
  let object = InputChecklistTask::new(text="New Task")
  let json = @json.to_json(object)
  let parsed : InputChecklistTask = @json.from_json(json)
  inspect(parsed.text, content="New Task")
}

///|
test "InputChecklist JSON round-trip" {
  let task1 = InputChecklistTask::new(text="Buy milk")
  let task2 = InputChecklistTask::new(text="Buy eggs")
  let object = InputChecklist::new(header="Groceries", tasks=[task1, task2])
  let json = @json.to_json(object)
  let parsed : InputChecklist = @json.from_json(json)
  inspect(parsed.header, content="Groceries")
  inspect(parsed.tasks.length(), content="2")
  inspect(parsed.tasks[0].text, content="Buy milk")
  inspect(parsed.tasks[1].text, content="Buy eggs")
}

///|
test "ChecklistTasksDone JSON round-trip" {
  let object = ChecklistTasksDone::new()
  let json = @json.to_json(object)
  let _parsed : ChecklistTasksDone = @json.from_json(json)
}

///|
test "ChecklistTasksAdded JSON round-trip" {
  let object = ChecklistTasksAdded::new()
  let json = @json.to_json(object)
  let _parsed : ChecklistTasksAdded = @json.from_json(json)
}

///|
test "ChecklistTask from fixed JSON" {
  let json = @json.parse(
    #|{"id":3,"text":"Buy groceries","is_done":false}
  )
  let task : ChecklistTask = @json.from_json(json)
  inspect(task.id, content="3")
  inspect(task.text, content="Buy groceries")
  inspect(task.is_done, content="false")
}

///|
test "ChecklistTask from fixed JSON done" {
  let json = @json.parse(
    #|{"id":7,"text":"Write tests","is_done":true}
  )
  let task : ChecklistTask = @json.from_json(json)
  inspect(task.id, content="7")
  inspect(task.text, content="Write tests")
  inspect(task.is_done, content="true")
}

///|
test "Checklist from fixed JSON" {
  let json = @json.parse(
    #|{"header":"Today's Tasks","tasks":[{"id":1,"text":"Review PR","is_done":true},{"id":2,"text":"Write docs","is_done":false}]}
  )
  let checklist : Checklist = @json.from_json(json)
  inspect(checklist.header, content="Today's Tasks")
  inspect(checklist.tasks.length(), content="2")
  inspect(checklist.tasks[0].id, content="1")
  inspect(checklist.tasks[0].text, content="Review PR")
  inspect(checklist.tasks[0].is_done, content="true")
  inspect(checklist.tasks[1].id, content="2")
  inspect(checklist.tasks[1].text, content="Write docs")
  inspect(checklist.tasks[1].is_done, content="false")
}

///|
test "InputChecklistTask from fixed JSON" {
  let json = @json.parse(
    #|{"text":"Pick up package"}
  )
  let task : InputChecklistTask = @json.from_json(json)
  inspect(task.text, content="Pick up package")
}

///|
test "InputChecklist from fixed JSON" {
  let json = @json.parse(
    #|{"header":"Weekend Errands","tasks":[{"text":"Grocery shopping"},{"text":"Bank transfer"}]}
  )
  let checklist : InputChecklist = @json.from_json(json)
  inspect(checklist.header, content="Weekend Errands")
  inspect(checklist.tasks.length(), content="2")
  inspect(checklist.tasks[0].text, content="Grocery shopping")
  inspect(checklist.tasks[1].text, content="Bank transfer")
}

///|
test "ChecklistTasksDone from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : ChecklistTasksDone = @json.from_json(json)
}

///|
test "ChecklistTasksAdded from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : ChecklistTasksAdded = @json.from_json(json)
}
