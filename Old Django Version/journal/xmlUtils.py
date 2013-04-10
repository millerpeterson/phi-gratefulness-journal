import pdb
import datetime
from xml.etree.ElementTree import ElementTree, Element, SubElement

from Gratefulness import log, settings
from models import Entry

def importXml(filePath, user):
    entriesTree = ElementTree()
    entriesRead = 0
    try:
        entriesTree.parse(filePath)
        for entry in entriesTree.getroot().findall('entry'):   
            nextDate = datetime.datetime.strptime(entry.find('date').text, settings.DATE_FORMAT)
            nextBody = entry.find('body').text
            newEntry = Entry(author = user,
                             dateWritten = nextDate,
                             body = nextBody)
            newEntry.save()
            entriesRead += 1
        return entriesRead
    except:
        log.error("Error while parsing XML during import.")
        return None
    
def exportXml(path, user):
    outTree = ElementTree(Element('entries'))
    root = outTree.getroot()
    for entry in Entry.objects.filter(author = user):
        entryElement = SubElement(root, 'entry')
        entryBody = SubElement(entryElement, 'body')
        entryBody.text = entry.body
        entryDate = SubElement(entryElement, 'date')
        entryDate.text = entry.dateWritten.strftime(settings.DATE_FORMAT)
    try:
        outTree.write(path)
    except:
        log.error("Error while writing entries to XML during export.")
        return None
    return path
        