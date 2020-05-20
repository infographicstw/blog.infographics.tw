require! <[fs path cheerio]>
json = JSON.parse(fs.read-file-sync 'infographics.json' .toString!)
hash = {}
json.map -> hash[it.text] = it

files = fs.read-file-sync 'info-files' .toString!split(\\n).filter(->it)
for f in files =>
  $ = cheerio.load(fs.read-file-sync f .toString!)
  img = $("img").attr("src")
  text = $(".entry-title.single-title").text()
  tags = Array.from($(".byline.vcard a")).map(-> $(it).text!).splice(1)
  desc = ($($(".entry-content.cf p")[0]).text! or "").substring(0,64)
  hash[text].img = img
  hash[text].tags = tags
  hash[text].desc = desc
  #data = fs.read-file-sync f .toString!
  #data = data.replace /http:\/\//g, 'https://'
  #fs.write-file-sync f, data
  /*
  p = path.dirname(f)
  console.log f
  fs.write-file-sync path.join(p, "index.pug"), """
  extends /base.pug
  block body
    include index.html
  """
  */
fs.write-file-sync 'posts.pug', "- var posts = #{JSON.stringify([v for k,v of hash])}"
