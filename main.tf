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

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "custom_rules" {
    for_each = var.custom_rules == null ? [] : var.custom_rules
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action

      rate_limit_duration  = try(custom_rules.value.rate_limit_duration, null)
      rate_limit_threshold = try(custom_rules.value.rate_limit_threshold, null)
      group_rate_limit_by  = try(custom_rules.value.group_rate_limit_by, null)

      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions
        content {
          operator           = match_conditions.value.operator
          negation_condition = try(match_conditions.value.negation_condition, null)
          match_values       = try(match_conditions.value.match_values, null)
          transforms         = try(match_conditions.value.transforms, null)

          dynamic "match_variables" {
            for_each = match_conditions.value.match_variables
            content {
              variable_name = match_variables.value.variable_name
              selector      = try(match_variables.value.selector, null)
            }
          }
        }
      }
    }
  }

  dynamic "policy_settings" {
    for_each = var.policy_settings == null ? [] : [var.policy_settings]
    content {
      enabled                                   = try(policy_settings.value.enabled, null)
      mode                                      = try(policy_settings.value.mode, null)
      request_body_check                        = try(policy_settings.value.request_body_check, null)
      file_upload_limit_in_mb                   = try(policy_settings.value.file_upload_limit_in_mb, null)
      max_request_body_size_in_kb               = try(policy_settings.value.max_request_body_size_in_kb, null)
      request_body_inspect_limit_in_kb          = try(policy_settings.value.request_body_inspect_limit_in_kb, null)
      js_challenge_cookie_expiration_in_minutes = try(policy_settings.value.js_challenge_cookie_expiration_in_minutes, null)
    }
  }

  dynamic "managed_rules" {
    for_each = var.managed_rules == null ? [] : [var.managed_rules]
    content {

      dynamic "exclusion" {
        for_each = coalesce(try(managed_rules.value.exclusions, null), [])
        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = exclusion.value.selector_match_operator

          dynamic "excluded_rule_set" {
            for_each = exclusion.value.excluded_rule_sets
            content {
              type    = excluded_rule_set.value.type
              version = excluded_rule_set.value.version

              dynamic "rule_group" {
                for_each = excluded_rule_set.value.rule_groups
                content {
                  rule_group_name = rule_group.value.rule_group_name
                  excluded_rules  = rule_group.value.excluded_rules
                }
              }
            }
          }
        }
      }

      dynamic "managed_rule_set" {
        for_each = try(managed_rules.value.managed_rule_sets, [])
        content {
          type    = managed_rule_set.value.type
          version = managed_rule_set.value.version

          dynamic "rule_group_override" {
            for_each = coalesce(try(managed_rule_set.value.rule_group_overrides, null), [])
            content {
              rule_group_name = rule_group_override.value.rule_group_name

              dynamic "rule" {
                for_each = try(rule_group_override.value.rules, [])
                content {
                  id      = rule.value.id
                  enabled = try(rule.value.enabled, null)
                  action  = try(rule.value.action, null)
                }
              }
            }
          }
        }
      }
    }
  }
}
