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

--#ENDPOINT GET /keystore/key/{key}
res = Keystore.get({key=request.parameters.key})
return res

--#ENDPOINT DELETE /keystore/key/{key}
res = Keystore.delete({key=request.parameters.key})
return res

--#ENDPOINT POST /keystore/command
local command = request.body
res = Keystore.command(command)
return res

--#ENDPOINT GET /user/listRoles
response.message = User.listRoles()

--#ENDPOINT POST /user/createRole
local t = tostring(request.body.name)
if t ~= "nil" then
  local parameters = {role_id = request.body.id , parameter = {{name=request.body.name}}}
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
  id = request.body.id
}
return User.getUser(parameters)

--#ENDPOINT POST /user/updateUser
local parameters = {
  id = request.body.id,
  name = request.body.name,
  password = request.body.password,
  original_password = request.body.oldpassword,
  status = request.body.status
}
response.message = User.updateUser(parameters)

--#ENDPOINT POST /user/deleteUser
local parameters = {id = request.body.id}
response.message = User.deleteUser(parameters)

--#ENDPOINT POST /user/deleteSocial
local parameters = {
  consumer = request.body.consumer,
  redirect = request.body.redirect,
  client_id = request.body.id,
  client_secret = request.body.secret
}
response.message = User.deleteSocial(parameters)

--#ENDPOINT POST /user/activateUser
local parameters = {
  name = request.body.name,
  email = request.body.email,
  password = request.body.password
}
local activation_code = User.createUser(parameters)
response = User.activateUser({["code"] = activation_code})

--#ENDPOINT POST /user/deleteRole
local parameters = {
 ["role_id"] = request.body.id
 }
response.message = User.deleteRole(parameters)

--#ENDPOINT GET /user/listPerms
return User.listPerms()

--#ENDPOINT POST /user/createPerms
local parameters = {
  end_point = request.body.endpoint,
  method = request.body.method
}
response = User.createPermission(parameters)

--#ENDPOINT POST /user/getRole
local parameters = {
  role_id = request.body.id
}
response.message = User.getRole(parameters)

--#ENDPOINT POST /user/getUserToken
local parameters = {
  email = request.body.email,
  password = request.body.password
}
return User.getUserToken(parameters)

--#ENDPOINT POST /user/deletePerms
local parameters = {
  ["perm_id"] = request.body.permId
}
return User.deletePerm(parameters)

--#ENDPOINT POST /user/listUserRoles
response.message = User.listUserRoles({id = request.body.id})

--#ENDPOINT POST /user/assignUser
local parameters = {
  id = request.body.userId,
  roles = {
    {
      role_id = request.body.roleId,
      parameters = {
        {
          name = request.body.name,
          value = request.body.value
        }
      }
    }
  }
}
response.message = User.assignUser(parameters)

--#ENDPOINT POST /user/getSocial
local parameters = {
  consumer = request.body.consumer
}
response.message = User.getSocial(parameters)

--#ENDPOINT POST /user/updateSocial
local parameters = {
  consumer = request.body.consumer,
  redirect = request.body.redirect,
  client_id = request.body.id,
  client_secret = request.body.secret
}
return User.updateSocial(parameters)

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

--#ENDPOINT GET /twilio/listCall
response.message = Twilio.listCall()

--#ENDPOINT POST /twilio/createCall
local out = Twilio.createCall({
  From = request.body.From,
  To = request.body.To,
  Url = request.body.Url
 })
response.message = out

--#ENDPOINT GET /twilio/listMessage
response.message = Twilio.listMessage()

--#ENDPOINT POST /twilio/postMessage
local out = Twilio.postMessage({
  From = request.body.From,
  To = request.body.To,
  Body = request.body.Body
})
response.message = out

--#ENDPOINT POST /twilio/getCall
local parameters ={
  CallSid = request.body.CallSid
}
response.message = Twilio.getCall(parameters)

--#ENDPOINT POST /twilio/deleteCall
local parameters ={
  CallSid = request.body.CallSid
}
response.message = Twilio.deleteCall(parameters)

--#ENDPOINT POST /twilio/getMessage
local parameters ={
  MessageSid = request.body.MessageSid
}
response.message = Twilio.getMessage(parameters)

--#ENDPOINT POST /twilio/deleteMessage
local parameters ={
  MessageSid = request.body.MessageSid
}
response.message = Twilio.deleteMessage(parameters)

--#ENDPOINT POST /twilio/listMedia
local parameters ={
  MessageSid = request.body.MessageSid
}
response.message = Twilio.listMedia(parameters)

--#ENDPOINT POST /twilio/getMedia
local parameters ={
  MessageSid = request.body.MessageSid,
  MediaSid = request.body.MediaSid
}
response.message = Twilio.getMedia(parameters)

--#ENDPOINT POST /twilio/deleteMedia
local parameters ={
  MessageSid = request.body.MessageSid,
  MediaSid = request.body.MediaSid
}
response.message = Twilio.deleteMedia(parameters)

--#ENDPOINT GET /twilio/createTwiml
xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Say voice="woman">You got a call!</Say>
</Response>
]]
response.message = xml

--#ENDPOINT GET /keystore/info
response.message = Keystore.info()

--#ENDPOINT POST /email/send
local to = request.body.to
local subject = request.body.subject
local text = request.body.text

local emailData = {
  to = {
    to,
  },
  subject = subject,
  text = text,
}
return Email.send(emailData)

--#ENDPOINT GET /email/info
response.message = Email.getSettings()

--#ENDPOINT POST /device/rpcCall
local pid = request.body.pid
local sn = request.body.sn
local resource = request.body.res

local calls = {}
local ret = Device.rpcCall({pid = pid, calls = {{
  id = "1",
  procedure = "lookup",
  arguments = {"alias", tostring(sn)}
}}})
if type(ret) ~= "table" then
  return "error in lookup rpc call"
end

if ret[1].status ~= "ok" then
  return "error in lookup: "..ret[1].result
end
local rid = ret[1].result
for k, alias in ipairs(resource) do
  table.insert(calls, {id=alias, procedure="read", arguments={{alias=alias}, {limit=1}}})
end
local rpcret = Device.rpcCall({
  pid = pid,
  auth = {client_id = rid},
  calls = calls
})

return rpcret
