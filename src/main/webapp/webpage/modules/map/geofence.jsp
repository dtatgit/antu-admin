<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>地理围栏</title>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css"/>
    <script type="text/javascript" src="https://cache.amap.com/lbs/static/addToolbar.js"></script>

    <script src="${ctxStatic}/common/js/jquery-3.3.1.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/coordinate-convert.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/jeeplus.js" type="text/javascript"></script>

    <style>
        html,
        body,
        #container {
            width: 100%;
            height: 100%;
        }
    </style>

    <script type="text/javascript">
        function save(setFenceDatas) {

            var jsonStr = "";
            if(lnglatArr.length>0){
                jsonStr = JSON.stringify(lnglatArr);
            }

            setFenceDatas(jsonStr);
            jp.success("选择成功！");

            var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
            parent.layer.close(dialogIndex);
        }
    </script>
</head>
<body>
<div id="container"></div>
<%--<div class="button-group">--%>
    <%--<input name="openmap" type="button" class="button" value="地图编辑" onClick="mapeditor();"/>--%>
    <%--<input name="closemap" type="button" class="button" value="地图编辑完成" onClick="closeEditPolygon();"/>--%>
    <%--&lt;%&ndash;<input name="savemap" type="button" class="button" value="保存围栏数据" onClick="savedata();"/>&ndash;%&gt;--%>
<%--</div>--%>

<div class="input-card" style="width: 200px">
    <h4 style="margin-bottom: 10px; font-weight: 600">绘制覆盖物</h4>
    <button class="btn" onclick="mapeditor()" style="margin-bottom: 5px">绘制多边形</button>
    <button class="btn" onclick="closeEditPolygon()" style="margin-bottom: 5px">结束编辑</button>
</div>

<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=1350cad6a9086d35e9478ab8c3f7afe0&plugin=AMap.PolyEditor"></script>
<%--<script type="text/javascript">--%>
    <%--var lng ='${map.lng}';--%>
    <%--var lat ='${map.lat}';--%>


    <%--var map = new AMap.Map("container", {--%>
        <%--resizeEnable: true--%>
    <%--});--%>

    <%----%>
    <%--if(!lng || !lat){--%>
        <%--layer.msg('没有查询到您的位置信息！', {--%>
            <%--icon: 0--%>
        <%--});--%>
        <%--throw "————————";  //抛出一个异常来终止下面js的执行--%>
    <%--}--%>
    <%--console.log("转换前：lng:" + lng+",lat:"+lat);--%>

    <%--//wgs84转国测局坐标--%>
    <%--var wgs84togcj02 = coordtransform.wgs84togcj02(lng, lat);--%>
    <%--console.log("转换后：" + wgs84togcj02);--%>
    <%--lng = wgs84togcj02[0];--%>
    <%--lat = wgs84togcj02[1];--%>

    <%--var lnglat = new AMap.LngLat(lng, lat); //一个点--%>
    <%--map.setZoomAndCenter(16, lnglat);  //重新设置中心点--%>

    <%--//根据坐标获取地址--%>
    <%--regeoCode();--%>

    <%--var marker = addMarker();--%>

    <%--//构建信息窗体--%>
    <%--var infoWindow = openInfo();--%>

    <%--marker.on("mouseover", function(e) {--%>
        <%--infoWindow.open(map, e.target.getPosition());--%>
    <%--});--%>
    <%--marker.on("mouseout", function() {--%>
        <%--infoWindow.close()--%>
    <%--});--%>

    <%--// 实例化点标记--%>
    <%--function addMarker() {--%>
        <%--marker = new AMap.Marker({--%>
            <%--position: [lng,lat]--%>
        <%--});--%>
        <%--marker.setMap(map);--%>

        <%--return marker;--%>
    <%--}--%>

    <%--//在指定位置打开信息窗体--%>
    <%--function openInfo() {--%>
        <%--//构建信息窗体中显示的内容--%>
        <%--var info = [];--%>
        <%--info.push("<div><span style=\"font-size:14px;color:#0A8021\">位置信息</span>");--%>
        <%--info.push("<div style='line-height:1.8em;font-size:12px;margin-top:6px;'> 车辆编号 ：${gpsVehicle.vehicleNumber}");--%>
        <%--info.push("模组编号 ：${gpsVehicle.gpsModule.sid}");--%>
        <%--info.push("RSSI ：${map.rssi==null?'':map.rssi}");--%>
        <%--info.push("外部电压 ：${map.externalVoltage==null?'':map.externalVoltage}");--%>
        <%--info.push("电池电压 ：${map.batteryVoltage==null?'':map.batteryVoltage}");--%>
        <%--info.push("更新时间 ：${map.utcDatetime}");--%>
        <%--info.push("</div></div>");--%>
        <%--infoWindow = new AMap.InfoWindow({--%>
            <%--content:  info.join("<br/>"),  //使用默认信息窗体框样式，显示信息内容--%>
            <%--offset: new AMap.Pixel(0, -30)--%>
        <%--});--%>
        <%--return infoWindow;--%>
        <%--//infoWindow.open(map, marker.getPosition());--%>
    <%--}--%>

    <%--//根据坐标获取地址--%>
    <%--var geocoder;--%>
    <%--function regeoCode() {--%>
        <%--if(!geocoder){--%>
            <%--geocoder = new AMap.Geocoder({--%>
                <%--city: "010", //城市设为北京，默认：“全国”--%>
                <%--radius: 1000 //范围，默认：500--%>
            <%--});--%>
        <%--}--%>
        <%--var lnglatArr  = [lng,lat];--%>

        <%--geocoder.getAddress(lnglatArr, function(status, result) {--%>
            <%--if (status === 'complete'&&result.regeocode) {--%>
                <%--var address = result.regeocode.formattedAddress;--%>
                <%--document.getElementById('divAddress').innerText = address;--%>
            <%--}else{--%>
                <%--log.error('根据经纬度查询地址失败')--%>
            <%--}--%>
        <%--});--%>
    <%--}--%>

<%--</script>--%>
<script>
    //定义地图画图工具  中心点等
    var map = new AMap.Map("container", {
        resizeEnable: true,
        center: [115.48,38.85],//地图中心点
        zoom: 13 //地图显示的缩放级别
    });

    var lnglatArr = [];

    var datas;
    var beginNum = 0;
    var clickListener ;
    var beginPoints;
    var beginMarks ;
    //多边形 全局变量
    var polygonEditor;
    var polydatas=[];
    var resPolygon = [];
    var resNum = 0;
    //加载后台数据
    //getdata();
    init();
    //给地图增加单击事件及初始化数据
    function init(){
        beginPoints = [];
        beginMarks = [];
        beginNum = 0;
        polygonEditor = '';
        clickListener = AMap.event.addListener(map, "click", mapOnClick);
        //  var str = '[{"J":39.91789947393269,"G":116.36744477221691,"lng":116.367445,"lat":39.917899},{"J":39.91184292800211,"G":116.40658356616223,"lng":116.406584,"lat":39.911843},{"J":39.88616249265181,"G":116.37963272998047,"lng":116.379633,"lat":39.886162}]';
        //   var arr = json2arr(datas);
        //  createPolygon(arr);
    }
    //后台有数据的话初始化数据
    function init2(){
        beginPoints = [];
        beginMarks = [];
        beginNum = 0;
        polygonEditor = '';
        // clickListener = AMap.event.addListener(map, "click", mapOnClick);
        var arr = json2arr(datas);
        var polygon = createPolygon(arr);
        polygonEditor = createEditor(polygon);
    }
    //点击事件 点的监听保存
    function mapOnClick(e) {
        // document.getElementById("lnglat").value = e.lnglat.getLng() + ',' + e.lnglat.getLat()
        beginMarks.push(addMarker(e.lnglat));
        beginPoints.push(e.lnglat);
        beginNum++;
        if(beginNum == 3){
            AMap.event.removeListener(clickListener);
            var polygon = createPolygon(beginPoints);
            polygonEditor = createEditor(polygon);
            clearMarks();
        }
    };

    //多边形实例
    function createPolygon(arr){
        var polygon = new AMap.Polygon({
            map: map,
            path: arr,
            strokeColor: "#0000ff",
            strokeOpacity: 1,
            strokeWeight: 3,
            fillColor: "#f5deb3",
            fillOpacity: 0.35
        });
        return polygon;
    }
    //多边形实例编辑、关闭 事件等
    function createEditor(polygon){
        var  polygonEditor = new AMap.PolyEditor(map, polygon);
        polygonEditor.open();
        AMap.event.addListener(polygonEditor,'end',polygonEnd);
        return polygonEditor;
    }
    //编辑方法
    function mapeditor() {
        polygonEditor.open();
    }
    //关闭方法  关闭时会调用end事件
    function closeEditPolygon(){
        polygonEditor.close();
    }
    //end的事件  返回 多边形坐标位置
    function polygonEnd(res){

        polydatas.length = 0;
        polydatas.push(res.target);


        lnglatArr.length = 0;

        let sourceData = res.target.toString();
        console.log("path111:"+res.target.getPath()+",res.target:"+res.target);  //和
        let polydatasArray =  sourceData.split(";");
        for(let i=0;i<polydatasArray.length;i++){

            let arrTemp = polydatasArray[i].split(",");
            let lng = arrTemp[0];
            let lat = arrTemp[1];

            var lnglatData = {
                lng:lng,
                lat:lat
            };

            lnglatArr.push(lnglatData);
        }


        //某一点是否在多边形中
        //   resPolygon.push(res.target);
        //alert(resPolygon[resNum].contains([116.386328, 39.913818]));
        //console 打印
        //  appendHideHtml(resNum,res.target.getPath());

        //  resNum++;
        //   init();
    }
    //console 打印
    function appendHideHtml(index,arr){
        var strify = JSON.stringify(arr);
        var html = '<input type="hidden" id="index'+index+'" name="paths[]" value="'+strify+'">';
        $('body').append(html);
        console.log(html);
    }


    // 清除标记
    function clearMarks(){
        map.remove(beginMarks);
    }
    //json to  arr
    function json2arr(json){
        var arr = JSON.parse(json);
        var res = [];
        for (var i = 0; i < arr.length; i++) {
            var line = [];
            line.push(arr[i].lng);
            line.push(arr[i].lat);
            res.push(line);
        };
        return res;
    }


    // 实例化点标记
    function addMarker(lnglat) {

        var marker = new AMap.Marker({
            icon: "http://webapi.amap.com/theme/v1.3/markers/n/mark_b.png",
            position: lnglat
        });
        marker.setMap(map);
        return marker;
    }

    /**============================后台数据交互ajax */
//保存
    function savedata() {
        // alert(polydatas);
        // console.log("aa:"+polydatas+"ss:"+polydatas.join(';'));
        // var param = {"org":1,"polydatas":polydatas.join(';')};
        //
        // $.ajax({
        //     url:"savePoly", //后台处理程序
        //     type:'post',         //数据发送方式
        //     dataType: 'json',
        //     data:param,
        //     async: true,
        //     success:function(data){
        //         alert("数据保存成功！");
        //     }
        // });

        $.ajax({
            type : "post",//向后台请求的方式，有post，get两种方法
            url : "${ctx}/fence/electronicFence/ajax/addfence",//url填写的是请求的路径
            cache : false,//缓存是否打开
            data : {//请求的数据，
                polydatas:polydatas.join(';')
            },
            dataType : 'json',//请求的数据类型
            success : function(data) {//请求的返回成功的方法
                if(data.success){
                    alert("数据保存成功！");
                }
            },
            error : function(XMLHttpRequest, textStatus, errorThrown) {//请求的失败的返回的方法
                alert("操作失败，请稍后再次尝试！");
            }
        });
    }
    //查询
    function getdata() {
        var param = {"sid":1,"infos":2};
        $.ajax({
            url:"getPoly", //后台处理程序
            type:'post',         //数据发送方式
            dataType: 'json',
            data:param,
            async: true,
            success:function(data){
                if(data!=null){
                    datas=JSON.stringify(data);
                    init2();
                }else{
                    init();
                }

            }
        });


    }


</script>
</body>
</html>
