--#ENDPOINT PUT /user/{email}
local ret = User.createUser({
  email = request.parameters.email,
  name = request.parameters.email,
  password = request.body.password
})
if ret.status ~= nil then
  response.code = ret.status
  response.message = tostring(from_json(ret.error).message)
else
  local domain = string.gsub(request.uri, 'https?://(.-/)(.*)', '%1')
  local text = "Hi " .. request.parameters.email .. ",\n"
  text = text .. "Click this link to verify your account:\n"
  text = text .. "https://" .. domain .. "verify/" .. ret;
  Email.send({
    from = 'Sample App <mail@exosite.com>',
    to = request.parameters.email,
    subject = ("Signup on " .. domain),
    text = text
  })
end

