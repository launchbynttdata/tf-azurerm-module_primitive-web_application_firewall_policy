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

variable "product_family" {
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  type        = string
  default     = "dso"
}

variable "product_service" {
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  type        = string
  default     = "app"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    waf_policy = {
      name       = "wafpolicy"
      max_length = 60
    }
    resource_group = {
      name       = "rg"
      max_length = 60
    }
  }
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
