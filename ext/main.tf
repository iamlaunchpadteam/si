resource "aws_cloudformation_stack" "network" {
  name = "networking-stack"

  parameters = {
    ExternalId = "1"
  }

  template_body = file("./ext/Saviynt_CFT_Analyzer_IGA_DC_PAM.json")
  capabilities = ["CAPABILITY_IAM"]
}