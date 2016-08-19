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
local parameters = {role_id = request.body.id}
response = User.createRole(parameters)

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


--#ENDPOINT GET /timer/schedule
local parameters =
  {message = "qwer",timer_id = "he",duration = 1 * 1000,schedule = {daily = "true"}}
if Timer.schedule() == nil then
  response.message = Timer.schedule(parameters)
else
  response.message = Timer.schedule(parameters)
  local cancelparameters =
  {timer_id = "he"}
  response = Timer.cancel(cancelparameters)
end

--#ENDPOINT GET /timer/sendAfter
local parameters =
  {message = "qwer",timer_id = "Af",duration = 1 * 1000,schedule = {daily = "true"}}
if Timer.schedule() == nil then
  response.message = Timer.sendAfter(parameters)
else
  response.message = Timer.sendAfter(parameters)
  local cancelparameters =
  {timer_id = "Af"}
  response = Timer.cancel(cancelparameters)
end

--#ENDPOINT GET /timer/sendInterval
local parameters =
  {message = "qwer",timer_id = "In",duration = 1 * 1000,schedule = {daily  = "true"}}
if Timer.schedule() == nil then
  response.message = Timer.sendInterval(parameters)
else
  response.message = Timer.sendInterval(parameters)
  local cancelparameters =
  {timer_id = "In"}
  response = Timer.cancel(cancelparameters)
end

--#ENDPOINT GET /timer/cancel
local parameters = {
 timer_id = "quis anim aute"
 }
response.message = Timer.cancel(parameters)

--#ENDPOINT GET /timer/cancelAll
response.message = Timer.cancelAll()
