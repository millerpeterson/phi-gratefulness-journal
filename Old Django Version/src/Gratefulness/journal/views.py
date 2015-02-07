import pdb
import uuid
import os
from datetime import datetime, timedelta


from django.http import HttpResponse, HttpResponseRedirect, HttpResponseForbidden
from django.shortcuts import render_to_response
from django.conf import settings
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.contrib import auth
from django.template.loader import get_template
from django.template import Context
from django.utils import simplejson
from django.utils.functional import wraps

import xmlUtils
from projectUtils import projectPath
from Gratefulness import log
from models import Entry, ApiKey
from forms import ImportXMLForm, LoginForm

# Decorator for validating an auth token.

def token_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if ('key' in request.REQUEST):        
            user = auth.authenticate(key=request.REQUEST['key'])
            if (user != None):
                auth.login(request, user)                
                return view_func(request, *args, **kwargs)
        return HttpResponseForbidden()
    return _wrapped_view

# Ajax Methods

@token_required
def createOrUpdate(request):
    
    log.info("createOrUpdate")
    
    updatedId = -1
   
    if (request.method == 'POST'):
                
        entryId = int(request.POST['entryId'])
        log.debug("entryId %d" % entryId)
        
        if (entryId == -1):
            entry = Entry()
            entry.author = getDefaultAuthor()
            entry.dateWritten = datetime.now()            
        else:
            entry = Entry.objects.get(pk = entryId)
        
        entry.body = request.POST['body']        
        entry.save()      
        updatedId = entry.id
        
    return HttpResponse(simplejson.dumps({ 'updatedId': updatedId }),\
                        mimetype='application/javascript')

# For now assume we are always searching backwards.
@token_required
def getRelativeEntryId(request):
    
    refEntryId = request.POST['refEntryId']
    relDays = request.POST['relDays']
    tolerance = request.POST['tolerance']

    log.info("getRelativeEntryId %s %s %s" % (refEntryId, relDays, tolerance))                
    
    refDate = Entry.objects.get(pk = refEntryId).dateWritten
    relEntry = Entry.getEntryNearDate(refDate - timedelta(days = int(relDays)),
                                      timedelta(days = int(tolerance)))
    retrievedId = -1
    if (relEntry != None):
        retrievedId = relEntry.pk
    return HttpResponse(simplejson.dumps({ 'entryId' : retrievedId }),
                        mimetype='application/javascript')

@token_required
def renderBody(request):
    
    entryId = request.POST['entryId']    
    
    log.info("renderBody " + entryId)    
    
    entry = Entry.objects.get(pk = entryId)
    log.info(renderEntryBody(entry))
    return HttpResponse(renderEntryBody(entry))

@token_required
def renderUI(request):    
    
    entryId = request.POST['entryId']    
    caption = request.POST['caption']
    
    log.info("renderUI " + entryId)
    
    entry = Entry.objects.get(pk = entryId)        
    return HttpResponse(renderEntryUI(entry, 'view', caption))

# HTML Methods

@login_required
def importXML(request):
    
    if (request.method == 'POST'):
        uploadedFile = request.FILES['xmlFile']
        tempFilepath = projectPath("tmp/%s.xml" % uuid.uuid1())
        try:
            destFile = None
            destFile = open(tempFilepath, 'wb+')
            for chunk in uploadedFile.chunks():
                destFile.write(chunk)
        except IOError:
            return HttpResponse('Failed to upload XML file; aborting import.')
        finally:
            if (destFile != None):    
                destFile.close()
        # TODO: instead of using default author use current request user.
        entriesRead = xmlUtils.importXml(tempFilepath, getDefaultAuthor())        
        if (entriesRead == None):
            return HttpResponse("Failed to read XML file; aborting import.")
        else:
            return HttpResponse("Successfully read %d entries from XML." % entriesRead)
        # TODO: file cleanup?
    else:
        form = ImportXMLForm()
        return render_to_response('journal/ImportXML.html',
                                  { 'form': form})
@login_required
def exportXML(request):
    outputFilename = "%s.xml" % uuid.uuid1()
    downloadFilePath = os.path.join(settings.DOWNLOAD_FOLDER_PATH, outputFilename)
    # TODO: instead of using default author use current request user.
    xmlUtils.exportXml(downloadFilePath, getDefaultAuthor())
    return render_to_response('journal/ExportXML.html',
                              { 'filename': outputFilename })

@login_required
def single(request, entryId):
    entryHtml = ''
    if (entryId != None):
        entryId = int(entryId)        
        entry = Entry.objects.get(pk = entryId)
        entryHtml = renderEntryUI(entry, 'view')
    return render_to_response('journal/Single.html',
                              { 'entry': entry,
                              'entryHtml': entryHtml })

@login_required
def new(request):    
    entry = Entry()
    return render_to_response('journal/New.html',
                              { 'entry': entry,
                                'entryHtml': renderEntryUI(entry, 'edit', 'New Entry') })

# Shared Helper Methods

def getDefaultAuthor():
    return User.objects.get(username__exact = 'miller')

def renderEntryUI(entry, viewMode='view', caption=''):
    entryTemplate = get_template('journal/Entry.html')
    return entryTemplate.render(Context({'entry': entry,
                                         'caption': caption,                                        
                                         'viewMode': viewMode }))
                                                                               
def renderEntryBody(entry):
    bodyTemplate = get_template('journal/EntryBody.html')
    return bodyTemplate.render(Context({'entry': entry }))

# Authentication Methods

#TODO: Look into session expiry.
def login(request):
    #pdb.set_trace()
    if (request.method == 'POST'):
        loginForm = LoginForm(request.POST)
        if loginForm.is_valid():            
            username = loginForm.cleaned_data['username']
            password = loginForm.cleaned_data['password']
            user = auth.authenticate(username=username, password=password)
            if (user != None and user.is_active):
                auth.login(request, user)
                #TODO: redirect to next if it's set
                return HttpResponseRedirect('/journal/new')
        return render_to_response('journal/Login.html',
                                  {'form': loginForm })            
    else:
        #TODO: set 'next'
        loginForm = LoginForm()
        return render_to_response('journal/Login.html',
                                  {'form': loginForm })
        
def logout(request):
    auth.logout(request)
    return HttpResponseRedirect('/accounts/loggedout/')

def loggedOut(request):
    return render_to_response('journal/Logout.html')

def getApiKey(request):
    apiKey = ''
    if (request.method == 'POST'):
        if (not request.user.is_authenticated()):
            username = request.POST['username']
            password = request.POST['password']
            user = auth.authenticate(username=username, password=password)
        else:
            user = request.user
        if (user != None):
            try:
                keyObj = ApiKey.objects.get(user=user)
                apiKey = keyObj.key
            except ApiKey.DoesNotExist:
                pass
    return HttpResponse(simplejson.dumps({ 'apiKey' : apiKey }),
                        mimetype='application/javascript')

                                        