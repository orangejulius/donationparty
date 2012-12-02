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
PUSHER_APP_ID = '32795'


#Amazon SES
AWS_ACCESS_KEY_ID = 'AKIAIUPWVZ2ROGYLKWJQ'
AWS_SECRET_ACCESS_KEY = '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'
EMAIL_BACKEND = 'django_ses.SESBackend'