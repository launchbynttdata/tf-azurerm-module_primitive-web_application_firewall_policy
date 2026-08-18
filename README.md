# tf-azurerm-module_primitive-web_application_firewall_policy

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module provisions an web application firewall policy for use with application gateway.

## Usage

See [examples/complete](examples/complete) for a full working example.

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines `pre-commit` hooks for Terraform formatting, validation, documentation generation, and detect-secrets. Hooks are installed when you run `make configure`. Go linting runs via `make lint` in local development and CI, not via pre-commit.

### Terratest examples

Post-deploy tests in `tests/post_deploy_functional/` and `tests/post_deploy_functional_readonly/` target `examples/complete` via an explicit folder constant in each `main_test.go`. Adding another example (for example `examples/minimal`) requires a new test entry point or updating that constant; it is not picked up automatically.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.
2. Ensure you are signed into the appropriate cloud provider (e.g. Azure) for the module under test in your current console session.
3. Run the Terraform and Golang linters:

```
make lint
```

4. Once linters pass, run integration tests (apply, test, destroy):

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, are performed in CI. Running them locally before opening a PR helps ensure a smooth review.

### Review & Merge Process

Open a Pull Request to the default (`main`) branch. The PR title must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format to merge and to drive semantic versioning.

Ensure CI workflows pass, address review feedback, and obtain approvals required by `CODEOWNERS`.

### Automatic Updates

Shared configuration and workflow files are largely managed through [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton). Avoid one-off edits to copied skeleton files in this repository unless necessary (for example `.gitignore` entries for generated artifacts). Use `copier check-update` / `copier update` when refreshing from the skeleton.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_web_application_firewall_policy.waf_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | Custom rules of the firewall policy. | <pre>list(object({<br/>    name      = string<br/>    priority  = number<br/>    rule_type = string<br/>    action    = string<br/><br/>    rate_limit_duration  = optional(string)<br/>    rate_limit_threshold = optional(number)<br/>    group_rate_limit_by  = optional(string)<br/><br/>    match_conditions = list(object({<br/>      match_variables = list(object({<br/>        variable_name = string<br/>        selector      = optional(string)<br/>      }))<br/>      operator           = string<br/>      negation_condition = optional(bool)<br/>      match_values       = optional(list(string))<br/>      transforms         = optional(list(string))<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | Managed rules of the firewall policy. | <pre>object({<br/>    exclusions = optional(list(object({<br/>      match_variable          = string<br/>      selector                = string<br/>      selector_match_operator = string<br/>      excluded_rule_sets = list(object({<br/>        type    = string<br/>        version = string<br/>        rule_groups = list(object({<br/>          rule_group_name = string<br/>          excluded_rules  = list(string)<br/>        }))<br/>      }))<br/>    }))),<br/>    managed_rule_sets = list(object({<br/>      type    = string<br/>      version = string<br/>      rule_group_overrides = optional(list(object({<br/>        rule_group_name = string<br/>        rules = optional(list(object({<br/>          id      = number<br/>          enabled = optional(bool)<br/>          action  = optional(string)<br/>        })))<br/>      })))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "managed_rule_sets": [<br/>    {<br/>      "type": "OWASP",<br/>      "version": "3.2"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the firewall policy. | `string` | n/a | yes |
| <a name="input_policy_settings"></a> [policy\_settings](#input\_policy\_settings) | Policy settings of the firewall policy. | <pre>object({<br/>    enabled                                   = optional(bool)<br/>    mode                                      = optional(string)<br/>    request_body_check                        = optional(bool)<br/>    file_upload_limit_in_mb                   = optional(number)<br/>    max_request_body_size_in_kb               = optional(number)<br/>    request_body_inspect_limit_in_kb          = optional(number)<br/>    js_challenge_cookie_expiration_in_minutes = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": null,<br/>  "file_upload_limit_in_mb": null,<br/>  "js_challenge_cookie_expiration_in_minutes": null,<br/>  "max_request_body_size_in_kb": null,<br/>  "mode": null,<br/>  "request_body_check": null,<br/>  "request_body_inspect_limit_in_kb": null<br/>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the firewall policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the firewall policy. |
<!-- END_TF_DOCS -->
