

echo build Objective-C codes

protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/Common.proto
protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/Constants.proto
protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/Error.proto
protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/Message.proto
protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/User.proto
protoc --proto_path=./BarrageClient/Protocol/ --objc_out=./BarrageClient/Protocol/Gen ./BarrageClient/Protocol/Barrage.proto



#echo build C codes

#cd /java/protobuf-c-0.15/bin/

#./protoc-c --proto_path=/gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/ --c_out=/gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/Gen-c /gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/GameBasic.proto


echo build Java server codes

protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src  ./BarrageClient/Protocol/Common.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src  ./BarrageClient/Protocol/Constants.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src  ./BarrageClient/Protocol/Error.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src  ./BarrageClient/Protocol/Message.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src ./BarrageClient/Protocol/User.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageCoreServer/src ./BarrageClient/Protocol/Barrage.proto




echo build Java Android code

protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/Common.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/Constants.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/Error.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/Message.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/User.proto
protoc --proto_path=./BarrageClient/Protocol/ --java_out=../BarrageAndroid/MainApplication/app/src/main/java  ./BarrageClient/Protocol/Barrage.proto

