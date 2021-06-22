export { parseUrl }

function parseUrl(url) {
  if (url.match('</script>')) {
    var parsedUrl = url.replace(/.js"><\/script>/, '').replace(/<script src="/, '')
  } else if  (url.match(/.git$/)) {
    var parsedUrl = url.replace(/.git$/, '')
  } else {
    var parsedUrl = url
  }
  console.log(parsedUrl)
  if ( parsedUrl.split('//')[1].split('/').length < 3 ) {
    return parsedUrl.split('//')[1].split('/')[1] 
  } else {
    return parsedUrl.split('//')[1].split('/')[2] 
  }
}
