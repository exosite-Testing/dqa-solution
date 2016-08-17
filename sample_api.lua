--#ENDPOINT POST /timeseries/query
local res
local q = request.body.sql
res = Timeseries.query({q = q})
return res

--#ENDPOINT POST /timeseries/write
local res
local key = request.body.key
local value = request.body.value
res = Timeseries.write({ query = key.." value="..value })
return res

--#ENDPOINT POST /timeseries/command
local res = {}
local q = request.body.sql
res = Timeseries.command({q = q})
return res

--#ENDPOINT GET /keystore/list
return Keystore.list()

--#ENDPOINT GET /keystore/clear
return Keystore.clear()

--#ENDPOINT POST /keystore/set
local res = Keystore.set({key=request.body.key, value=request.body.value})
return res

--#ENDPOINT GET /keystore/{key}
res = Keystore.get({key=request.parameters.key})
return res

--#ENDPOINT DELETE /keystore/{key}
res = Keystore.delete({key=request.parameters.key})
return res

--#ENDPOINT POST /keystore/command
local command = request.body
res = Keystore.command(command)
return res

--#ENDPOINT GET /customer
return 'There is Murano, over'
