DATABASES = {
    'default': {
        'NAME': 'donationparty',
        'ENGINE': 'django.db.backends.mysql',
        'USER': 'donationparty',
        'PASSWORD': '',
        'HOST': '127.0.0.1',
    }
}

REDIS = {
    'username': '',
    'password': '',
    'host': 'location',
    'port': 6379,
}

STRIPE_SECRET = "sk_test_pqFpBoCmQXnKPUrtz8GEV1eO"
STRIPE_PUBLISHABLE = "pk_test_keQHvvSTgakPBql0xshuqR60"

