<?php    
// if(empty($_GET['token'])){
//     die('Error Token.');
// }

#防止CC
// error_reporting(0);
// if($_COOKIE["userip"])die("<script>alert('请求频率过高')</script>RMB-0.01");
// setcookie("userip",sha1(rand()),time()+3);//设定cookie存活时间3s

//获取用户真实IP
function get_real_ip()
{
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

//匹配CURL
function is_curl(){
	     @$regex_match.="/curl/";
	     return preg_match($regex_match, strtolower($_SERVER['HTTP_USER_AGENT'])); //如果UA中存在上面的关键词则返回真。
	}
    if(is_curl()){
        echo get_real_ip()."\n";
        die();
    }

//获取API数据
function get_ip_info(){
        $UserIP = 'https://img.cy/ip/?ip=';    
        if(empty($_GET['ip'])){    
            $UserIP .= get_real_ip();   
            }else {
            $UserIP .= $_GET['ip'];    
        }
        return file_get_contents($UserIP);
    }
    
    
//检查IP合法性
function IP_Check(){
	     @$regex_match.="/^(?:(?:1[0-9][0-9]\.)|(?:2[0-4][0-9]\.)|(?:25[0-5]\.)|(?:[1-9][0-9]\.)|(?:[0-9]\.)){3}(?:(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5])|(?:[1-9][0-9])|(?:[0-9]))$/";
	     return preg_match($regex_match, strtolower($_GET['ip'])); 
	}
//检查内网IP
function IP_NatCheck(){
	     @$regex_match.="/^(127\.0\.0\.1)|(localhost)|(10\.\d{1,3}\.\d{1,3}\.\d{1,3})|(172\.((1[6-9])|(2\d)|(3[01]))\.\d{1,3}\.\d{1,3})|(192\.168\.\d{1,3}\.\d{1,3})$/";
	     return preg_match($regex_match, strtolower($_GET['ip'])); 
}
    if(isset($_GET['ip']) and IP_Check()!=true){
        if(empty($_GET['ip'])){
            echo "Fuck IP";
            die();
            }else{
            echo "Fuck U";
            die();
        }

    }elseif (IP_NatCheck() == true) {
        if(isset($_GET['json'])){
            echo '{"error":{"code":400,"type":"Bad Request","message":"IP error"},"data":{"addr":null}}';
            die();
        }
        die("内网IP");
    }
        
    //返回原始Json数据
    if(isset($_GET['json'])){
        echo get_ip_info();
        die();
    }
    

    $IP_info=json_decode(get_ip_info());
        //echo file_get_contents($UserIP);    
        //var_dump(json_decode($IP_info, true));
        echo $IP_info->data->ip."</br>";
        echo $IP_info->data->rgeo->country.$IP_info->data->rgeo->province.$IP_info->data->rgeo->city.'市'.$IP_info->data->addr."</br>";

?>
<div style="display:none"><script type="text/javascript">document.write(unescape("%3Cspan id='cnzz_stat_icon_1279572092'%3E%3C/span%3E%3Cscript src='https://s4.cnzz.com/z_stat.php%3Fid%3D1279572092%26online%3D1%26show%3Dline' type='text/javascript'%3E%3C/script%3E"));</script></div>
