// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
# COMMON
variable "name" {
  description = "Name of the firewall policy."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "custom_rules" {
  description = "Custom rules of the firewall policy."
  type = list(object({
    name      = string
    priority  = number
    rule_type = string
    action    = string

    rate_limit_duration  = optional(string)
    rate_limit_threshold = optional(number)
    group_rate_limit_by  = optional(string)

    match_conditions = list(object({
      match_variables = list(object({
        variable_name = string
        selector      = optional(string)
      }))
      operator           = string
      negation_condition = optional(bool)
      match_values       = optional(list(string))
      transforms         = optional(list(string))
    }))
  }))
  default = null
}

variable "policy_settings" {
  description = "Policy settings of the firewall policy."
  type = object({
    enabled                                   = optional(bool)
    mode                                      = optional(string)
    request_body_check                        = optional(bool)
    file_upload_limit_in_mb                   = optional(number)
    max_request_body_size_in_kb               = optional(number)
    request_body_inspect_limit_in_kb          = optional(number)
    js_challenge_cookie_expiration_in_minutes = optional(number)
  })
  default = {
    enabled                                   = null
    mode                                      = null
    request_body_check                        = null
    file_upload_limit_in_mb                   = null
    max_request_body_size_in_kb               = null
    request_body_inspect_limit_in_kb          = null
    js_challenge_cookie_expiration_in_minutes = null
  }
}

variable "managed_rules" {
  description = "Managed rules of the firewall policy."
  type = object({
    exclusions = optional(list(object({
      match_variable          = string
      selector                = string
      selector_match_operator = string
      excluded_rule_sets = list(object({
        type    = string
        version = string
        rule_groups = list(object({
          rule_group_name = string
          excluded_rules  = list(string)
        }))
      }))
    }))),
    managed_rule_sets = list(object({
      type    = string
      version = string
      rule_group_overrides = optional(list(object({
        rule_group_name = string
        rules = optional(list(object({
          id      = number
          enabled = optional(bool)
          action  = optional(string)
        })))
      })))
    }))
  })
  default = {
    managed_rule_sets = [
      {
        type    = "OWASP"
        version = "3.2"
      }
    ]
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
