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

PUSHER_KEY = 'b42a0a6cea9cc26341de'
PUSHER_SECRET = 'ad69664d70e01728f0d5'
PUSHER_APP_ID = '32797'

#Amazon SES
AWS_ACCESS_KEY_ID = 'AKIAIY3EENQ2ZO2D4JXA'
AWS_SECRET_ACCESS_KEY = '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'
EMAIL_BACKEND = 'django_ses.SESBackend'
