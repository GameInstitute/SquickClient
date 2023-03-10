-- Test Net Client

require("Net.Client")
print("Test Net.Client")


local netClient = NetClient.New(nil)
netClient:Connect("172.26.2.169", "8080")
netClient:SendBytes("TESSSSS")
coroutine.resume(coroutine.create(netClient.Execute), netClient, "ojbk")

