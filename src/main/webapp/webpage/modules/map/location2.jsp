<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>位置信息</title>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css"/>
    <script src="${ctxStatic}/common/js/jquery-3.3.1.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/coordinate-convert.js" type="text/javascript"></script>
    <script src="${ctxStatic}/plugin/layui/layer/layer.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/dateutils.js" type="text/javascript"></script>
    <style>
        html,
        body,
        #container {
            width: 100%;
            height: 100%;
        }
        .carinfor{
            margin: 10px;
            border: 1px solid #ddd;
            padding: 10px;
            box-shadow: 2px 0px 2px rgba(0,0,0,0.2);
            background: #fff;
        }
        .carinfor p{margin-bottom: 5px}
        .carinfor p:last-child{margin-bottom: 0}
    </style>
</head>
<body>
<div class="carinfor">
    <p>
      车辆编号：${ttatVehicle.vehicleNumber}<br/>
    </p>
    <p>
       当前地址：<span id="divAddress"></span>
    </p>
</div>
<div id="container"></div>

<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.14&key=1350cad6a9086d35e9478ab8c3f7afe0&plugin=AMap.Geocoder"></script>
<script type="text/javascript">
    var lng ='${map.lng}';
    var lat ='${map.lat}';


    var map = new AMap.Map("container", {
        resizeEnable: true
    });

    if(!lng || !lat){
        layer.msg('没有查询到您的位置信息！', {
            icon: 0
        });
        throw "————————";  //抛出一个异常来终止下面js的执行
    }
    console.log("转换前：lng:" + lng+",lat:"+lat);

    //wgs84转国测局坐标
    var wgs84togcj02 = coordtransform.wgs84togcj02(lng, lat);
    console.log("转换后：" + wgs84togcj02);
    lng = wgs84togcj02[0];
    lat = wgs84togcj02[1];

    var lnglat = new AMap.LngLat(lng, lat); //一个点
    map.setZoomAndCenter(16, lnglat);  //重新设置中心点

    //根据坐标获取地址
    regeoCode();

    var marker = addMarker();

    //构建信息窗体
    var infoWindow = openInfo();

    marker.on("mouseover", function(e) {
        infoWindow.open(map, e.target.getPosition());
    });
    marker.on("mouseout", function() {
        infoWindow.close()
    });

    // 实例化点标记
    function addMarker() {
        marker = new AMap.Marker({
            position: [lng,lat]
        });
        marker.setMap(map);

        return marker;
    }

    //在指定位置打开信息窗体
    function openInfo() {
        //构建信息窗体中显示的内容
        var info = [];
        info.push("<div><span style=\"font-size:14px;color:#0A8021\">位置信息</span>");
        info.push("<div style='line-height:1.8em;font-size:12px;margin-top:6px;'> 车辆编号 ：${ttatVehicle.vehicleNumber}");
        info.push("设备编号 ：${ttatVehicle.devId}");
        <%--info.push("RSSI ：${map.rssi==null?'':map.rssi}");--%>
        <%--info.push("外部电压 ：${map.externalVoltage==null?'':map.externalVoltage}");--%>
        <%--info.push("电池电压 ：${map.batteryVoltage==null?'':map.batteryVoltage}");--%>
        info.push("更新时间 ：${map.utcDatetime}");
        info.push("</div></div>");
        infoWindow = new AMap.InfoWindow({
            content:  info.join("<br/>"),  //使用默认信息窗体框样式，显示信息内容
            offset: new AMap.Pixel(0, -30)
        });
        return infoWindow;
        //infoWindow.open(map, marker.getPosition());
    }

    //根据坐标获取地址
    var geocoder;
    function regeoCode() {
        if(!geocoder){
            geocoder = new AMap.Geocoder({
                city: "010", //城市设为北京，默认：“全国”
                radius: 1000 //范围，默认：500
            });
        }
        var lnglatArr  = [lng,lat];

        geocoder.getAddress(lnglatArr, function(status, result) {
            if (status === 'complete'&&result.regeocode) {
                var address = result.regeocode.formattedAddress;
                document.getElementById('divAddress').innerText = address;
            }else{
                console.log("根据经纬度查询地址失败");
            }
        });
    }

</script>
<script>
    // var ws =new WebSocket("ws://localhost:9876?connectName=tttt123");
    // ws.onopen = function (event) {
    //     console.log("opened");
    //     ws.send("Hello Tio WebSocket,哈喽 华为！！！");
    // }
    // ws.onmessage=function (p1) {
    //     console.log("ttt-->"+p1.data);
    // }
</script>
</body>
</html>
