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
PUSHER_KEY = '71880b602ec7534b0b4f'
PUSHER_SECRET = '838c288267e6f358756f'
PUSHER_APP_ID = '32797'
