from django.core.management.base import BaseCommand, CommandError
from donationparty.models import *

class Command(BaseCommand):
    args = 'none'
    help = 'Runs cron tasks'

    def handle(self, *args, **options):
        Round.expire_rounds()
