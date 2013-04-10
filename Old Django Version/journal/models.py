from datetime import datetime, time, timedelta
import pdb
import hashlib
import base64
import random

from django.db import models
from django.contrib.auth.models import User

class Entry(models.Model):
	
	author 		= models.ForeignKey(User)
	dateWritten = models.DateTimeField(verbose_name = 'Date')
	body		= models.TextField()
	
	def __unicode__(self):
		return self.dateWritten.__str__()
		
	@classmethod
	def getEntryNearDate(cls, targetDate, toleranceDelta):
		
		targetDateTime = datetime.combine(targetDate, time())
		exactDateMatches = Entry.objects.filter(dateWritten__year = targetDate.year)\
									.filter(dateWritten__month = targetDate.month)\
									.filter(dateWritten__day = targetDate.day)
		if (exactDateMatches.count() > 0):
			return exactDateMatches[0]
		
		# We didn't find an entry exactly on the target date, so if
		# there's no tolerance for deviation from the target, we didn't find
		# anything.
		if (toleranceDelta == None):
			return None
		
		# A tolerance was given. Look for the closest entry within the 
		# given tolerance. 				
		rangeStart = targetDateTime - toleranceDelta
		rangeEnd = targetDateTime + toleranceDelta + timedelta(days = 1) - timedelta(seconds = 1)
		entriesInRange = Entry.objects.filter(dateWritten__range = (rangeStart, rangeEnd))
		
		#pdb.set_trace()
		
		if (entriesInRange.count() == 0):
			return None
		
		closestEntry = None
		smallestDelta = None
		for entry in entriesInRange:			
			nextDelta = abs(entry.dateWritten - targetDateTime)
			if ((closestEntry == None) or (nextDelta < smallestDelta)):
				smallestDelta = nextDelta
				closestEntry = entry
		return closestEntry
	
class ApiKey(models.Model):
	
	user = models.ForeignKey(User)
	key = models.CharField(max_length=128)
	
	@classmethod
	def generateKey(cls, user):
		apiKey = base64.b64encode(hashlib.sha256(str(random.getrandbits(256))).digest(), 
								random.choice(['rA','aZ','gQ','hH','hG','aR','DD'])).rstrip('==')
		key = ApiKey(user=user, key=apiKey)
		key.save()
		
	def __unicode__(self):
		return "%s: %s" % (self.user.username, self.key)
	