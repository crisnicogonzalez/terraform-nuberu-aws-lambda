variable "triggers" {
  type    = map(object({}))
  default = {}

  validation {
    condition = alltrue([
      contains(keys(var.triggers), "event_bridge") ? var.triggers["event_bridge"] != "" : true,
      contains(keys(var.triggers), "alb") ? var.triggers["alb"] == {} : true
    ])
    error_message = "Alb trigger config must be empty object, event_bridge config must be a valid cron expression.\n"
  }
}

variable "function_name" {
  type    = string
  default = null

  validation {
    condition     = var.function_name != null && length(var.function_name) > 0
    error_message = "Function name is empty"
  }
}

variable "timeout_in_seconds" {
  type    = number
  default = 1

  validation {
    condition     = var.timeout_in_seconds > 0 && var.timeout_in_seconds <= 900
    error_message = "Timeout must be between 1 and 900 seconds.\n"
  }
}

variable "description" {
  type    = string
  default = ""

  validation {
    condition     = length(var.description) <= 256 && length(var.description) > 0
    error_message = "Description must be less than 256 characters and no null\n"
  }
}

variable "create_github_repository" {
  type    = bool
  default = true
}

variable "memory_size_in_mb" {
  type    = number
  default = 128
}


variable "create_function_url" {
  type = bool
  default = false
}
