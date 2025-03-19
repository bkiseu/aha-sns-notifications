provider "aws" {
    region  = "us-west-2"
    default_tags {
      tags = {
        "Product"     = "Shared Services"
        "Component"   = "aha"
        "Layer"       = "permission-set"
        "Environment" = "dev"
      }
    }
}
