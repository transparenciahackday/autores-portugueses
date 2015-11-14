
from BeautifulSoup import BeautifulSoup
import urllib
import glob
import re

# Open CSV
CSVfile = open('autores.csv','w')
CSVfile.write("id;nome;data_nascimento;local_nascimento;data_morte;local_morte;biografia;foto\n")

# Load all html files in an array
files = glob.glob("*html")

count = 0



# Check if string has numbers
def has_date(s):
    return any(i.isdigit() for i in s)

# Iterate over each file
for file in files:

  # Print filename
  print file
  # Write Filename/ID
  CSVfile.write(file.encode('utf-8')[0:-5])
  CSVfile.write(';')

  r = urllib.urlopen(file)

  data = r.read()
  soup = BeautifulSoup(data)

  # Find the autor
  #name = soup.find(id="detalheAutorNome")
  authorData = soup.find('span', id=re.compile('DetalheNome'))
  if authorData is not None:
    name = authorData.getText().encode('utf-8')
    # Write name
    CSVfile.write(name)
    CSVfile.write(';')
    print name

  # Find the birth and death information 
  birthDeathData = soup.find('span', id=re.compile('NascFalec'))
  if birthDeathData is not None:
    birthDeathDataClean = birthDeathData.getText().encode('utf-8')[1:-1]
    #print birthDeathDataClean

    # Stupid error on the pages, check if there is actually dates
    if has_date(birthDeathDataClean):

      # Birthdate
      birthdate = re.findall("\d+", birthDeathDataClean)[0]
      if birthdate is not None:
        # Write birthdate
        CSVfile.write(birthdate)
        print birthdate
      CSVfile.write(';')

      # Birthplace
      birthplace = birthDeathDataClean.split(',')[0]
      if birthplace is not None:
        # Write birthplace
        CSVfile.write(birthplace)
        print birthplace
      CSVfile.write(';')

      # Check if there is death information
      if len(birthDeathDataClean.split('-')) == 2:

        # Deathdate
        if len(re.findall("\d+", birthDeathDataClean)) == 2:
          deathdate = re.findall("\d+", birthDeathDataClean)[1]
          # Write deathdate
          CSVfile.write(deathdate)
          CSVfile.write(';')
          print deathdate
        else:
          CSVfile.write('?')
          CSVfile.write(';')


        # Deathplace
        deathplace = birthDeathDataClean.split('-')[1].split(',')[0].strip()
        # Write deathdate
        CSVfile.write(deathplace)
        CSVfile.write(';')
        print deathplace

      else:
        # If the author is still alive
        CSVfile.write(';')

    else:
      CSVfile.write(';;;;')

  # If it has biography
  biography = soup.find('span', id=re.compile('DetalheBiografia'))
  if biography is not None:
    # Write biography
    #CSVfile.write(biography.getText().encode('utf-8'))
    print biography.getText().encode('utf-8')
  CSVfile.write(';')

  # Photo, if it has
  photo = soup.find('span', id=re.compile('detalheAutorImagem'))
  if photo is not None:
     # Write photo
    CSVfile.write(photo)
    print photo


  # Check which links it has
  CSVfile.write("\n")
  # Increment count
  count +=1
  #print count
  print ""

  #if count == 5:
   # raise SystemExit





