resource "random_password" "password" {
  length    = 10
  special   = false
  min_lower = 10
}
