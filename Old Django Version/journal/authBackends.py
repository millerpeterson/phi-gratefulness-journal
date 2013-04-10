from models import ApiKey
from django.contrib.auth.models import User
from django.contrib.auth.backends import ModelBackend

class ApiKeyBackend(ModelBackend):
    
    def authenticate(self, key):
        try:
            key = ApiKey.objects.get(key=key)
            return key.user
        except ApiKey.DoesNotExist:
            return None