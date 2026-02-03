custom_rules = [
  {
    name      = "allowips"
    priority  = 10
    rule_type = "MatchRule"
    action    = "Allow"

    match_conditions = [
      {
        match_variables = [
          {
            variable_name = "RemoteAddr"
          }
        ]
        operator     = "IPMatch"
        match_values = ["192.0.2.10", "198.51.100.0/24"]
        transforms   = []
      },
      {
        match_variables = [
          {
            variable_name = "RequestHeaders"
            selector      = "User-Agent"
          }
        ]
        operator           = "Contains"
        negation_condition = true
        match_values       = ["curl"]
        transforms         = ["Lowercase"]
      }
    ]
  },
  {
    name      = "ratelimit"
    priority  = 20
    rule_type = "RateLimitRule"
    action    = "Block"

    rate_limit_duration  = "OneMin"
    rate_limit_threshold = 100
    group_rate_limit_by  = "ClientAddr"

    match_conditions = [
      {
        match_variables = [
          {
            variable_name = "RequestUri"
          }
        ]
        operator     = "Contains"
        match_values = ["/api"]
      }
    ]
  }
]

policy_settings = {
  enabled                                   = true
  mode                                      = "Prevention"
  request_body_check                        = true
  file_upload_limit_in_mb                   = 100
  max_request_body_size_in_kb               = 128
  request_body_inspect_limit_in_kb          = 128
  js_challenge_cookie_expiration_in_minutes = 30
}

managed_rules = {
  exclusions = [
    {
      match_variable          = "RequestHeaderNames"
      selector                = "x-ignore"
      selector_match_operator = "Equals"
      excluded_rule_sets = [
        {
          type    = "OWASP"
          version = "3.2"
          rule_groups = [
            {
              rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
              excluded_rules  = ["930120", "930130"]
            }
          ]
        }
      ]
    }
  ]

  managed_rule_sets = [
    {
      type    = "OWASP"
      version = "3.2"
      rule_group_overrides = [
        {
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
          rules = [
            {
              id      = 942100
              enabled = false
              action  = "Log"
            },
            {
              id = 942200
              # enabled/action omitted to cover optional path
            }
          ]
        }
      ]
    }
  ]
}

tags = {
  environment = "dev"
  owner       = "example"
}
