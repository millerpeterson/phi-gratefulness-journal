import pdb
import sys
import datetime
import xml.etree.ElementTree
import settings
import re
from xml.etree.ElementTree import ElementTree, Element, SubElement

tiddlyDateFormat = '%a, %d %b %Y %H:%M:%S %Z'

def convertTiddlyExport(inputFilepath, outputFilepath):
    inTree = ElementTree()
    inTree.parse(inputFilepath)
    outTree = ElementTree(Element('entries'))
    outRoot = outTree.getroot()    
    for item in inTree.getroot().findall('channel/item'):
        newEntry = SubElement(outRoot, 'entry')
        newEntryDate = SubElement(newEntry, 'date')
        newDate = datetime.datetime.strptime(item.find('pubDate').text, tiddlyDateFormat)
        newEntryDate.text = newDate.strftime(settings.DATE_FORMAT) 
        newEntryBody = SubElement(newEntry, 'body')
        htmlText = item.find('description').text
        bodyText = htmlText.replace('<br>', '\n');            
        bodyText = re.sub(r'\<.*?\>', "", bodyText)
        newEntryBody.text = bodyText
    outTree.write(outputFilepath)
    
if __name__ == '__main__':
    inFile = sys.argv[1]
    outFile = sys.argv[2]
    convertTiddlyExport(inFile, outFile)