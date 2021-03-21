variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "acr_identities" {
  type = map(map(string))
}