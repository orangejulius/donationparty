DATABASES = {
    'default': {
        'NAME': 'heroku_13e40e0b0a64db0',
        'ENGINE': 'django.db.backends.mysql',
        'USER': 'bcfed72b123f20',
        'PASSWORD': 'e8abd9b7',
        'HOST': 'us-cdbr-east-02.cleardb.com',
    }
}
REDIS = {
    'username': 'redistogo',
    'password': '9261980e79524bf95d732fb2025b43c2',
    'host': 'ray.redistogo.com',
    'port': 9649,
}

# STRIPE_SECRET = "sk_live_2TKQ9NK8dsOHasUihYDVnLlr"
# STRIPE_PUBLISHABLE = "pk_live_Et6aRkl9dHCLLOF3G75nkqji"

STRIPE_SECRET = "sk_test_pqFpBoCmQXnKPUrtz8GEV1eO"
STRIPE_PUBLISHABLE = "pk_test_keQHvvSTgakPBql0xshuqR60"


# PREPEND_WWW = True