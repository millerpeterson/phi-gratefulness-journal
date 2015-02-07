import os

from django.conf import settings

def projectPath(relPath):    
    return os.path.join(settings.PROJECT_PATH, relPath)