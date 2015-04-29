

echo build Objective-C codes

protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/Common.proto
protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/Constants.proto
protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/Error.proto
protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/Message.proto
protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/User.proto
protoc --proto_path=./Magic/Protocol/ --objc_out=./Magic/Protocol/Gen ./Magic/Protocol/Barrage.proto



#echo build C codes

#cd /java/protobuf-c-0.15/bin/

#./protoc-c --proto_path=/gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/ --c_out=/gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/Gen-c /gitdata/Draw_iPhone/Draw/GameServer/ProtocolBuffer/GameBasic.proto


echo build Java server codes

protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src  ./Magic/Protocol/Common.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src  ./Magic/Protocol/Constants.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src  ./Magic/Protocol/Error.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src  ./Magic/Protocol/Message.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src ./Magic/Protocol/User.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../MagicServer/CommonBusiness/src ./Magic/Protocol/Barrage.proto

echo build Java Android code

protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/Common.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/Constants.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/Error.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/Message.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/User.proto
protoc --proto_path=./Magic/Protocol/ --java_out=../../../BarrageAndroid/MainApplication/app/src/main/java  ./Magic/Protocol/Barrage.proto

