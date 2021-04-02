<?php
function get_real_ip(){
    $ip=FALSE;
    //客户端IP 或 NONE
    if(!empty($_SERVER["HTTP_CLIENT_IP"])){
        $ip = $_SERVER["HTTP_CLIENT_IP"];
    }
    //多重代理服务器下的客户端真实IP地址（可能伪造）,如果没有使用代理，此字段为空
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ips = explode (", ", $_SERVER['HTTP_X_FORWARDED_FOR']);
        if ($ip) { array_unshift($ips, $ip); $ip = FALSE; }
        for ($i = 0; $i < count($ips); $i++) {
            if (!eregi ("^(10│172.16│192.168).", $ips[$i])) {
                $ip = $ips[$i];
               break;
            }
        }
    }
    //客户端IP 或 (最后一个)代理服务器 IP
    return ($ip ? $ip : $_SERVER['REMOTE_ADDR']);
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    </head>
    <body>
        Remote Addr: <?php echo get_real_ip(); ?>        <hr>
        <h4>Your local IP addresses:</h4>
        <ul id="localip"></ul>
        <h4>Your public IP addresses:</h4>
        <ul id="publicip"></ul>
        <h4>Your IPv6 addresses:</h4>
        <ul id="ipv6"></ul>
        <iframe id="rtc_iframe" sandbox="allow-same-origin" style="display: none"></iframe>
        <script>
            //get the IP addresses associated with an account
            function getIPs(callback){
                var ip_dups = {};
                //compatibility for firefox and chrome
                var RTCPeerConnection = window.RTCPeerConnection
                    || window.mozRTCPeerConnection
                    || window.msRTCPeerConnection
                    || window.webkitRTCPeerConnection;
                var useWebKit = !!window.webkitRTCPeerConnection;
                //bypass naive webrtc blocking using an iframe
                if(!RTCPeerConnection){
                    var win = document.getElementById("rtc_iframe").contentWindow;
                    RTCPeerConnection = win.RTCPeerConnection
                        || win.mozRTCPeerConnection
                        || win.msRTCPeerConnection
                        || win.webkitRTCPeerConnection;
                    useWebKit = !!win.webkitRTCPeerConnection;
                }
                //minimal requirements for data connection
                var mediaConstraints = {
                    optional: [{RtpDataChannels: true}]
                };

                var servers = {
                  iceServers: [
                    {
                      urls: [
                        'stun:stun.l.google.com:19302?transport=udp',
                        'stun:stun1.l.google.com:19302?transport=udp',
                        'stun:stun2.l.google.com:19302?transport=udp',
                        'stun:stun3.l.google.com:19302?transport=udp',
                        'stun:stun4.l.google.com:19302?transport=udp',
                        "stun:stun.ekiga.net?transport=udp",
                        "stun:stun.ideasip.com?transport=udp",
                        "stun:stun.rixtelecom.se?transport=udp",
                        "stun:stun.schlund.de?transport=udp",
                        "stun:stun.stunprotocol.org:3478?transport=udp",
                        "stun:stun.voiparound.com?transport=udp",
                        "stun:stun.voipbuster.com?transport=udp",
                        "stun:stun.voipstunt.com?transport=udp",
                        "stun:stun.voxgratia.org?transport=udp"
                      ]
                    }
                  ]
                };
                //construct a new RTCPeerConnection
                var pc;
                try {
                  pc = new RTCPeerConnection(servers, mediaConstraints);
                } catch (e) {
                  return
                }
                function handleCandidate(candidate){
                  //match just the IP address
                  var ip_regex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/
                  var ip_addr = ip_regex.exec(candidate)[1];
                  //remove duplicates
                  if(ip_dups[ip_addr] === undefined)
                      callback(ip_addr);
                  ip_dups[ip_addr] = true;
                }
                //listen for candidate events
                pc.onicecandidate = function(ice){
                  //skip non-candidate events
                  if(ice.candidate)
                    handleCandidate(ice.candidate.candidate);
                };

                //create a bogus data channel
                pc.createDataChannel("bl");
                //create an offer sdp
                try {
                  pc.createOffer().then(function(result) {
                    pc.setLocalDescription(result);
                  });
                } catch (e) {
                  pc.createOffer().then(function(result) {
                    pc.setLocalDescription(result, function(){}, function(){});
                  }, function() {});
                }
                //wait for a while to let everything done
                setTimeout(function(){
                    //read candidate info from local description
                    var lines = pc.localDescription.sdp.split('\n');

                    lines.forEach(function(line){
                      if(line.indexOf('a=candidate:') === 0)
                        handleCandidate(line);
                    });
                }, 1000);
            }
            //insert IP addresses into the page
            getIPs(function(ip){
		console.log(ip);
                var li = document.createElement("li");
                li.textContent = ip;
                //local IPs
                if (ip.match(/^(192\.168\.|169\.254\.|10\.|172\.(1[6-9]|2\d|3[01]))/))
                  document.getElementById("localip").appendChild(li);
                //IPv6 addresses
                else if (ip.match(/^[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7}$/))
                  document.getElementById("ipv6").appendChild(li);
                //assume the rest are public IPs
                else
                  document.getElementById("publicip").appendChild(li);
            });
        </script>
    </body>
</html>
