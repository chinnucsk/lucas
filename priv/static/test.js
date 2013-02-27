$(document).ready(function(){

    var ssocket = new WebSocket("ws://localhost:8001/websocket/test", "test");
    document.getElementById("zz").value="haoba";
   function  text1(){
        var msg={
            type: "message",
            text: "success",
            socketid: -1 };
        ssocket.send(JSON.stringify(msg));
        document.getElementById("zz").value="ciao";
       };

   document.getElementById("zz").addEventListener("blur",text1,false);

   ssocket.onmessage = function(event){
        var msg1 = JSON.parse(event.data);
        if (msg1.type == "message")
           {
            document.getElementById("zz").value=msg1.text;
            };
       };
    
    });
