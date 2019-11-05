container_id = `docker ps | grep selenium`[0...5]
logs = `docker inspect #{container_id} | grep IPAddress`
addies = logs.split(',')
ip_address = addies[1].strip.gsub('"IPAddress": "','').gsub('"','')
IO.write('ip_address.txt', ip_address)