import os

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

PUSHER_KEY = 'd3e80976aa3d62546765'
PUSHER_SECRET = '7e5b213f489002fffa3c'
PUSHER_APP_ID = '32796'

#Amazon SES
AWS_ACCESS_KEY_ID = 'AKIAIUPWVZ2ROGYLKWJQ'
AWS_SECRET_ACCESS_KEY = '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'

#) PREPEND_WWW = True
