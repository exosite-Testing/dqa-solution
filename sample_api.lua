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

--#ENDPOINT GET /user/listUsers
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

--#ENDPOINT POST /user/createSocial
local parameters = {
  consumer = request.body.consumer,
  redirect = request.body.redirect,
  client_id = request.body.id,
  client_secret = request.body.secret
}
response = User.createSocial(parameters)

--#ENDPOINT POST /user/getCurrentUser
local parameters = {
  token = User.getUserToken({email=request.body.email, password=request.body.password})
}
return User.getCurrentUser(parameters)

--#ENDPOINT POST /user/getUser
local parameters = {
  id = 1
}
return User.getUser(parameters)

--#ENDPOINT POST /user/updateUser
local parameters = {
  id = 1,
  status = 0,
  name = request.body.name,
}
response.message = User.updateUser(parameters)

--#ENDPOINT GET /user/deleteUser
local parameters = {id = 1}
response.message = User.deleteUser(parameters)

--#ENDPOINT POST /user/deleteSocial
local parameters = {
  consumer = request.body.consumer,
  redirect = request.body.redirect,
  client_id = request.body.id,
  client_secret = request.body.secret
}
response.message = User.deleteSocial(parameters)

--#ENDPOINT POST /user/activateUsdr
local parameters = {
  name = request.body.name,
  email = request.body.email,
  password = request.body.password
}
local activation_code = User.createUser(parameters)
response = User.activateUser({["code"] = activation_code})

--#ENDPOINT POST /timer/schedule
resp = Timer.schedule(request.body)
response.message = resp
response.code = resp.status

--#ENDPOINT POST /timer/sendAfter
response.message = Timer.sendAfter(request.body)

--#ENDPOINT POST /timer/sendInterval
response.message = Timer.sendInterval(request.body)

--#ENDPOINT POST /timer/cancel
response.message = Timer.cancel(request.body)

--#ENDPOINT GET /timer/cancelAll
response.message = Timer.cancelAll()
