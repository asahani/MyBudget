json.extract! task, :id, :description, :due_by, :completed, :budget_id, :created_at, :updated_at
json.url task_url(task, format: :json)