secrets = [
  {
    name     = "testing/secret1"
    rotation = 0
    secret = {
      name     = "foo"
      password = null
    }
  },
  {
    name = "testing/secret2"
    secret = {
      key = "bar"
    }
  }
]
