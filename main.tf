// WARN random passwords appear in the state file
// NOTE using remote state ensures sensitive values are not stored locally

resource "random_password" "passwords" {
  // to simplify instantiaion of the secret, create a password for each
  for_each = {
    for i, val in var.secrets :
    val.name => val
  }

  length = var.password_length

  // TODO explore ways of making the rotation keeper time dependent
  keepers = {
    rotation = coalesce(lookup(each.value, "rotation", null), -1)
  }
}

resource "aws_secretsmanager_secret" "secret" {
  for_each = {
    for i, val in var.secrets :
    val.name => val
  }

  name = each.value.name
}

resource "aws_secretsmanager_secret_version" "secret" {
  for_each = {
    for i, val in var.secrets :
    val.name => val
  }

  secret_id = aws_secretsmanager_secret.secret[each.value.name].id

  // set the password attribute to the random resource created previously
  secret_string = jsonencode({
    for k, v in each.value.secret :
    k => coalesce(
      k == "password" ? null : v,
      random_password.passwords[each.value.name].result
    )
  })
}
