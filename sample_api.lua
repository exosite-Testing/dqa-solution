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

--#ENDPOINT GET /user/listRoles
response.message = User.listRoles()

--#ENDPOINT POST /user/createRole
local t = tostring(request.body.name)
if t ~= "nil" then
  local parameters = {role_id = request.body.id , parameter = {request.body.name}}
  response = User.createRole(parameters)
else
  local parameters = {role_id = request.body.id}
  response = User.createRole(parameters)
end

--#ENDPOINT GET /user/listusers
response.message = User.listUsers(parameters)

--#ENDPOINT POST /user/createUser
local parameters = {
 name = request.body.name,
 email = request.body.email,
 password = request.body.password
 }
response = User.createUser(parameters)

--#ENDPOINT GET /user/socialList
response.message = User.socialList()


--#ENDPOINT POST /timer/schedule
response.message = Timer.schedule(request.body)

--#ENDPOINT POST /timer/sendAfter
response.message = Timer.sendAfter(request.body)

--#ENDPOINT POST /timer/sendInterval
response.message = Timer.sendInterval(request.body)

--#ENDPOINT POST /timer/cancel
response.message = Timer.cancel(request.body)

--#ENDPOINT GET /timer/cancelAll
response.message = Timer.cancelAll()
