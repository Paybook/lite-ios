# lite-ios

A very simple and light interface to demonstrate how to take advantage of the Paybook Financial API (Sync) to pull information from Mexican Banks and Tax Authority.

# Rquirements.
- Xcode Version 7.3
- Cocoapods
- Paybook Sync API key


To make api requests for paybook methods, you will need set the api_url of the server in the file "Config.swift", or you can install lite-python and use local host.
```
let api_url : String = "<your url server>"
let api_key : String = "<your API key>"
```

#Install
- Use terminal to clone repository.
`git clone https://github.com/Paybook/lite-ios.git`
- Install and config [lite-python](https://github.com/Paybook/lite-python) 

#Install Cocoapods
1. If you haven't got Cocoapods installed, run: 
`gem install cocoapods` then
`pod setup`

2. Go your lite-ios directory and create a pod file with:
`$ pod init`
3. Open in xcode and replace the content with:
```
platform :ios, '9.0'
use_frameworks!

target 'LitePaybook' do
    use_frameworks!
  pod 'Alamofire', '~> 3.1.2'
  pod 'SocketRocket'
  
end
```
#API Request
You can config your API request in ApiCall file.

**signup**
```
var data = [
  username: String,
  password: String
]
signup (data: [String:String], callback: (()-> Void)?, callback_error: (()-> Void)?)
```

**login**
```
var data = [
  username: String,
  password: String
]
login (data: [String:String], callback: ((token : String?)-> Void), callback_error: (()-> Void)?)
```
