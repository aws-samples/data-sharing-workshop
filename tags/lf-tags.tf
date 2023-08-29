resource "aws_lakeformation_lf_tag" "tags-xgov" {
  key    = "sensitivity"
  values = ["public", "private", "confidential"]
}

resource "aws_lakeformation_lf_tag" "tags-share" {
  key    = "share"
  values = ["teams","central"]
}


resource "aws_lakeformation_lf_tag" "tags-sdept" {
  key    = "SourceDepartment"
  values = ["Department A","Department B","Department C","Agency 1","Agency 2","Agency 3"]
}

resource "aws_lakeformation_lf_tag" "tags-dtype" {
  key    = "DataType"
  values = ["Data","TestData","Schema","ProcessingStats","Synthetic"]
}

resource "aws_lakeformation_lf_tag" "tags-pci" {
  key    = "Is-PCI"
  values = ["True","False"] 
}

resource "aws_lakeformation_lf_tag" "tags-criminal" {
  key    = "Is-Criminal"
  values = ["True","False"] 
}

resource "aws_lakeformation_lf_tag" "tags-medical" {
  key    = "Is-Medical"
  values = ["True","False"] 
}

resource "aws_lakeformation_lf_tag" "tags-pi" {
  key    = "Is-PI"
  values = ["True","False"] 
}

resource "aws_lakeformation_lf_tag" "tags-handling" {
  key    = "SpecialHandling"
  values = ["None","DoNotCopy"]
 }

 resource "aws_lakeformation_lf_tag" "tags-domain" {
  key    = "Domain"
  values = ["Citizen","Reference","Assessment","SafeGuarding","Audit","Undefined"]
 }

  resource "aws_lakeformation_lf_tag" "tags-obfuscation" {
  key    = "Obfuscation"
  values = ["Masked","Encrypted","Tokenized","None"]
 }



