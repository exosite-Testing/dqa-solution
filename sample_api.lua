--#ENDPOINT POST /timeseries/query/
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
local q = request.parameters.sql
res = Timeseries.command({q = q})
return res
