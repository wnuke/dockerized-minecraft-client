import json
import sys
import requests
import pathlib

print('reading from ' + sys.argv[1])
with open(sys.argv[1], 'r') as file:
    data = file.read().replace('\n', '')

libraries = json.loads(data)['libraries']

for library in libraries:
    if library['url'] != '' & library['name'] != '':
        librarySplit = library['name'].split(':')
        libraryPath = librarySplit[0].replace('.', '/') + '/' + librarySplit[1] + '/' + librarySplit[2] + '/'
        libraryFileName = librarySplit[1] + '-' + librarySplit[2] + '.jar'
        libraryURL = library['url'] + '/' + libraryPath + libraryFileName
        pathlib.Path(sys.argv[2] + libraryPath).mkdir(parents=True, exist_ok=True)
        r = requests.get(libraryURL, allow_redirects=True)
        open(sys.argv[2] + libraryPath + libraryFileName, 'wb').write(r.content)
