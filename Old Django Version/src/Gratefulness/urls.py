from django.conf.urls.defaults import *
from django.conf import settings
from django.contrib import admin

import os

admin.autodiscover()

urlpatterns = patterns('',
    (r'^admin/', include(admin.site.urls)),
)

urlpatterns += patterns('journal.views',
                        (r'^journal/single/((?P<entryId>\d+)/)?$', 'single'),
                        (r'^journal/new/$', 'new'),
                        (r'^journal/createOrUpdate/$', 'createOrUpdate'),
                        (r'^journal/renderBody/$', 'renderBody'),
                        (r'^journal/renderUI/$', 'renderUI'),
                        (r'^journal/getRelativeEntryId/$', 'getRelativeEntryId'),
                        (r'^journal/import/$', 'importXML'),
                        (r'^journal/export/$', 'exportXML'),
                        (r'^accounts/login/$', 'login'),
                        (r'^accounts/logout/$', 'logout'),
                        (r'^accounts/loggedout/$', 'loggedOut'),
                        (r'^accounts/getApiKey/$', 'getApiKey'))

# Only serve static content in DEBUG mode.
if settings.DEBUG:
    urlpatterns += patterns('',
        (r'^content/(.*)$', 'django.views.static.serve', {'document_root': os.path.join(settings.PROJECT_PATH, '..', 'static_content')}),
    )