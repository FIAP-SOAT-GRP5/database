variable "dynamo_table_name" {
  description = " Unique within a region name of the table."
  type        = string
}

variable "hash_key" {
  description = "Attribute to use as the hash (partition) key."
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
}

variable "tags" {
  description = "A map of tags to populate on the created table."
}
