-- Unlua没有集成这个HTTP，不能使用, 已修复。

http = require("socket.http")
result = http.request("http://tflash.pwnsky.com/view/index")
print("收到数据", result)

