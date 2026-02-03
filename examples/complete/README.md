# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.2 |
| <a name="module_waf_policy"></a> [waf\_policy](#module\_waf\_policy) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"dso"` | no |
| <a name="input_product_service"></a> [product\_service](#input\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"app"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "resource_group": {<br>    "max_length": 60,<br>    "name": "rg"<br>  },<br>  "waf_policy": {<br>    "max_length": 60,<br>    "name": "wafpolicy"<br>  }<br>}</pre> | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | Custom rules of the firewall policy. | <pre>list(object({<br>    name      = string<br>    priority  = number<br>    rule_type = string<br>    action    = string<br><br>    rate_limit_duration  = optional(string)<br>    rate_limit_threshold = optional(number)<br>    group_rate_limit_by  = optional(string)<br><br>    match_conditions = list(object({<br>      match_variables = list(object({<br>        variable_name = string<br>        selector      = optional(string)<br>      }))<br>      operator           = string<br>      negation_condition = optional(bool)<br>      match_values       = optional(list(string))<br>      transforms         = optional(list(string))<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_policy_settings"></a> [policy\_settings](#input\_policy\_settings) | Policy settings of the firewall policy. | <pre>object({<br>    enabled                                   = optional(bool)<br>    mode                                      = optional(string)<br>    request_body_check                        = optional(bool)<br>    file_upload_limit_in_mb                   = optional(number)<br>    max_request_body_size_in_kb               = optional(number)<br>    request_body_inspect_limit_in_kb          = optional(number)<br>    js_challenge_cookie_expiration_in_minutes = optional(number)<br>  })</pre> | <pre>{<br>  "enabled": null,<br>  "file_upload_limit_in_mb": null,<br>  "js_challenge_cookie_expiration_in_minutes": null,<br>  "max_request_body_size_in_kb": null,<br>  "mode": null,<br>  "request_body_check": null,<br>  "request_body_inspect_limit_in_kb": null<br>}</pre> | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | Managed rules of the firewall policy. | <pre>object({<br>    exclusions = optional(list(object({<br>      match_variable          = string<br>      selector                = string<br>      selector_match_operator = string<br>      excluded_rule_sets = list(object({<br>        type    = string<br>        version = string<br>        rule_groups = list(object({<br>          rule_group_name = string<br>          excluded_rules  = list(string)<br>        }))<br>      }))<br>    }))),<br>    managed_rule_sets = list(object({<br>      type    = string<br>      version = string<br>      rule_group_overrides = optional(list(object({<br>        rule_group_name = string<br>        rules = optional(list(object({<br>          id      = number<br>          enabled = optional(bool)<br>          action  = optional(string)<br>        })))<br>      })))<br>    }))<br>  })</pre> | <pre>{<br>  "managed_rule_sets": [<br>    {<br>      "type": "OWASP",<br>      "version": "3.2"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_waf_policy_id"></a> [waf\_policy\_id](#output\_waf\_policy\_id) | The ID of the firewall policy. |
| <a name="output_waf_policy_name"></a> [waf\_policy\_name](#output\_waf\_policy\_name) | The name of the firewall policy. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group. |
<!-- END_TF_DOCS -->
