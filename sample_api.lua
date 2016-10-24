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
response.message = res
response.code = res.status

--#ENDPOINT POST /keystore/set/{firstNumber}/{endNumber}
local firstNumber = request.parameters.firstNumber
local endNumber = request.parameters.endNumber
for i = firstNumber, endNumber, 1 do
Keystore.set({ key = "key" .. i, value = "value" .. i})
end

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
  perm_id = request.body.permId
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

--#ENDPOINT GET /user/random
local s = ""
local str = ""
local r = ""
local randnum = 0
local randwordlen = 0
math.randomseed(os.time())
randnum = math.random(1,10)
for i = 1,randnum do
  randwordlen = math.random(1,10)
  str = ""
  for j = 1,randwordlen do
    if j == 1 then
      local ty = math.random(1,2)
        if ty == 1 then
          r = math.random(65,90)
        else
          r = math.random(97,122)
        end
        r = string.char(r)
    else
      local ty = math.random(1,3)
      if ty == 1 then
        r = math.random(48,57)
      elseif ty == 2 then
        r = math.random(65,90)
      else
        r = math.random(97,122)
      end
      r = string.char(r)
    end
    str = str .. r
  end
  s = s .. str .. ","
end
return s

--#ENDPOINT POST /user/createUserData
key = request.body.key
value = request.body.value
parameters = {id = request.body.id}
keyt = {}
valuet = {}
i=0
if key ~= nil and value ~= nil then
  i=0
  for str in string.gmatch(key, "([^" .. "," .. "]+)") do
    i=i+1
    keyt[i] = str
  end
  i=0
  for str in string.gmatch(value, "([^" .. "," .. "]+)") do
    i=i+1
    valuet[i] = str
  end
  if keyt ~= nil and valuet ~= nil then
    for num=1,i do
      local key_temp = keyt[num]
      local value_temp = valuet[num]
      parameters[key_temp] = value_temp
    end
    response = User.createUserData(parameters)
  else
    return "No value"
  end
end

--#ENDPOINT POST /user/listUserData
local parameters = {
  id = request.body.id;
}
response.message = User.listUserData(parameters)

--#ENDPOINT POST /user/updateUserData
key = request.body.key
value = request.body.value
parameters = {id = request.body.id}
keyt = {}
valuet = {}
i=0
if key ~= nil and value ~= nil then
  i=0
  for str in string.gmatch(key, "([^" .. "," .. "]+)") do
    i=i+1
    keyt[i] = str
  end
  i=0
  for str in string.gmatch(value, "([^" .. "," .. "]+)") do
    i=i+1
    valuet[i] = str
  end
  if keyt ~= nil and valuet ~= nil then
    for num=1,i do
      local key_temp = keyt[num]
      local value_temp = valuet[num]
      parameters[key_temp] = value_temp
    end
    return User.updateUserData(parameters)
  else
    return "No value"
  end
end

--#ENDPOINT POST /user/getUserData
local parameters = {
  id = request.body.id,
  key = request.body.key
}
return User.getUserData(parameters)

--#ENDPOINT POST /user/deleteUserData
local parameters = {
  id = request.body.id,
  keys = {request.body.keys}
  }
response.message = User.deleteUserData(parameters)

--#ENDPOINT POST /user/listRoleUsers
local parameters = {
  role_id = request.body.roleId
}
response.message = User.listRoleUsers(parameters)

--#ENDPOINT POST /user/addRoleParam
local parameters = {
  role_id = request.body.id,
  body = {
    {
      name = request.body.name
    }
  }
}
response.message = User.addRoleParam(parameters)

--#ENDPOINT POST /user/resetUserPassword
local parameters = {
  id = request.body.id,
  password = request.body.password
}
response.message = User.resetUserPassword(parameters)

--#ENDPOINT POST /user/deassignUser
response.message = User.deassignUser(parameters)
local parameters = {
  id = request.body.id,
  role_id = request.body.roleId
}
response.message = User.deassignUser(parameters)

--#ENDPOINT POST /user/listRolePerms
local parameters = {
role_id = request.body.roleId
}
response.message = User.listRolePerms(parameters)

--#ENDPOINT POST /user/addRolePerm
local parameters = {
      role_id = request.body.roleId,
      body = {
      {
      method = request.body.method,
      end_point = request.body.endpoint
      }
    }
  }
response.message = User.addRolePerm(parameters)

--#ENDPOINT POST /user/deleteRolePerm
local parameters = {
  role_id = request.body.roleId,
  perm_id = request.body.permId
}
return User.deleteRolePerm(parameters)

--#ENDPOINT POST /user/deassignUserParam
local parameters = {
  role_id = request.body.roleid,
  parameter_name = request.body.name,
  parameter_value = request.body.value,
  id = request.body.userid
}
response.message = User.deassignUserParam(parameters)

--#ENDPOINT POST /user/deassignUserParamName
local parameters = {
  id = request.body.userid,
  role_id = request.body.roleid,
  parameter_name = request.body.name
}
response.message = User.deassignUserParamName(parameters)

--#ENDPOINT POST /user/deleteRoleParam
local parameters = {
  role_id = request.body.id,
  parameter_name = request.body.name
}
response.message = User.deleteRoleParam(parameters)

--#ENDPOINT POST /user/deleteRoleParamValue
local parameters = {
  role_id = request.body.id,
  parameter_name = request.body.name,
  parameter_value = request.body.value
}
response.message = User.deleteRoleParamValue(parameters)

--#ENDPOINT POST /user/hasUserRoleParam
local parameters = {
  role_id = request.body.roleid,
  parameter_name = request.body.name,
  parameter_value = request.body.value,
  id = request.body.userid
}
response.message = User.hasUserRoleParam(parameters)

--#ENDPOINT POST /user/listRoleParamUsers
local parameters = {
  role_id = request.body.roleid,
  parameter_name = request.body.name,
  parameter_value = request.body.value
}
response.message = User.listRoleParamUsers(parameters)

--#ENDPOINT POST /user/listUserRoleParamValues
local parameters = {
  id = request.body.userid,
  role_id = request.body.roleid,
  parameter_name = request.body.name
}
response.message = User.listUserRoleParamValues(parameters)

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

--#ENDPOINT POST /twilio/listCall
return Twilio.listCall()

--#ENDPOINT POST /twilio/createCall
local out = Twilio.createCall({
  From = request.body.From,
  To = request.body.To,
  Url = request.body.Url
 })
response.message = out

--#ENDPOINT POST /twilio/listMessage
return Twilio.listMessage()

--#ENDPOINT POST /twilio/postMessage
local out = Twilio.postMessage({
  From = request.body.From,
  To = request.body.To,
  Body = request.body.Body
})
return out

--#ENDPOINT POST /twilio/getCall
local parameters ={
  CallSid = request.body.CallSid
}
return Twilio.getCall(parameters)

--#ENDPOINT POST /twilio/deleteCall
local parameters ={
  CallSid = request.body.CallSid
}
return Twilio.deleteCall(parameters)

--#ENDPOINT POST /twilio/getMessage
local parameters ={
  MessageSid = request.body.MessageSid
}
return Twilio.getMessage(parameters)

--#ENDPOINT POST /twilio/deleteMessage
local parameters ={
  MessageSid = request.body.MessageSid
}
return Twilio.deleteMessage(parameters)

--#ENDPOINT POST /twilio/listMedia
local parameters ={
  MessageSid = request.body.MessageSid
}
return Twilio.listMedia(parameters)

--#ENDPOINT POST /twilio/getMedia
local parameters ={
  MessageSid = request.body.MessageSid,
  MediaSid = request.body.MediaSid
}
return Twilio.getMedia(parameters)

--#ENDPOINT POST /twilio/deleteMedia
local parameters ={
  MessageSid = request.body.MessageSid,
  MediaSid = request.body.MediaSid
}
return Twilio.deleteMedia(parameters)

--#ENDPOINT GET /twilio/createTwiml
xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Say voice="woman">You got a call!</Say>
</Response>
]]
return xml

--#ENDPOINT GET /keystore/info
response.message = Keystore.info()

--#ENDPOINT POST /email/send
local toEmail = request.body.toEmail
local subject = request.body.subject
local text = request.body.text
local html = request.body.html

local emailData = {
  to = {
    toEmail,
  },
  subject = subject,
  text = text,
  html = html,
}
return Email.send(emailData)

--#ENDPOINT POST /email/info
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
