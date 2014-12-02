import urllib2
import urllib
import sys
from HTMLParser import HTMLParser

base_url = 'http://www.merriam-webster.com/browse/dictionary/'

global_cnt = 0

def get_attr_value(attrs, key):
  for attr in attrs:
    if(attr[0] == key):
      return attr[1]
  return ""

class MyHTMLParser(HTMLParser):
  def __init__(self):
    HTMLParser.__init__(self)
    self.isIn = False
    self.result = []
  def handle_starttag(self, tag, attrs):
    attr = get_attr_value(attrs, "class")
    if(tag == "ol" and attr == "toc"):
      self.isIn = True
    if(self.isIn):
      if(tag == "a"):
        self.result.insert(1, get_attr_value(attrs, "href"))
  def handle_endtag(self, tag):
    if(self.isIn and tag == "ol"):
      self.isIn = False

class WordHTMLParser(HTMLParser):
  def __init__(self):
    HTMLParser.__init__(self)
    self.result = []
  def handle_starttag(self, tag, attrs):
    global global_cnt
    href = get_attr_value(attrs, "href")
    if(tag == "a" and href.startswith("/dictionary/")):
      #self.result.insert(get_attr_value(attrs, "id"))
      print get_attr_value(attrs, "id")
      global_cnt = global_cnt + 1

def parserLetterSubPage(sub_page):
  print "###" + sub_page + "###"
  #description = raw_input("continue?\n")
  html = urllib2.urlopen(sub_page).read()
  parser = WordHTMLParser()
  parser.feed(html) 
  return parser.result

def parseWithLetter(letter):
  global global_cnt
  url = base_url + letter + ".htm"
  html = urllib2.urlopen(url).read()
  parser = MyHTMLParser()
  parser.feed(html)
  for page in parser.result:
    sub_url = base_url + urllib.quote(page)
    parserLetterSubPage(sub_url)
    sys.stderr.write(str(global_cnt) + "\n")


def main():
  for i in range(26):
    letter = chr(ord('a') + i)
    parseWithLetter(letter)

main()


