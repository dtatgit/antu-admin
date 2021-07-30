<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>轨迹回放</title>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css"/>
    <style>
        html, body, #container {
            height: 100%;
            width: 100%;
        }

        .input-card .btn{
            margin-right: 1.2rem;
            width: 9rem;
        }

        .input-card .btn:last-child{
            margin-right: 0;
        }
    </style>
    <style>
        .tablist2_float{
            position: absolute;
            top:0px;
            right: 0;
            z-index: 1000;
            height: 100%;
            overflow: auto;
            padding-top: 10px;
        }
        .tablist2{
            clear: both;
            overflow: hidden;
            margin-bottom: 10px;
            min-height: 85px;
            min-width: 39px;
        }
        .tablist2 .tab{
            position: absolute;
            background: #09b1b7;
            border: 1px solid #049da2;
            color: #fff;
            min-width: 10px;
            padding: 15px 12px;
            border-radius: 8px 0px 0px 8px;
            line-height: 28px;
            font-weight: bold;
            border-right: 0;
            cursor: pointer;
            font-size: 14px;
            display: block;
        }
        .tablist2 .tab.active{
            background: #f4f2ef;
            border-color: #e7e6e6;
            color: #09b1b7;
        }
        .tablist2 .tab.removeactive{
            right: 0;
        }
        .tablist2_box{
            background: #f4f2ef;
            padding: 10px;
            clear: both;
            overflow: hidden;
            border: 1px solid #e7e6e6;
            margin-left: 39px;
        }
        form {
            margin-bottom:0;
        }
        .row_map_ss{
            border: 1px solid #cfdce4;
            border-top: none;
            background: #fff;
            padding: 8px;
            font-size: 12px;
        }
        .row_map_ss:first-child,.row_map_btn
        {
            border-top: 1px solid #cfdce4;
        }
        .Wdate {
            border: #cfdce4 1px solid;
            height: 20px;
            padding: 5px 12px 5px 5px;
        }
        #search{
            width: 100%;
        }
        .row_map_btn{
            margin-top: 10px;
        }
    </style>
    <script src="${ctxStatic}/common/js/jquery-3.3.1.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/plugin/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/plugin/toastr/toastr.min.js"></script>
    <script src="${ctxStatic}/plugin/layui/layer/layer.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/jeeplus.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/coordinate-convert.js" type="text/javascript"></script>
</head>
<body>
<div class="tablist2_float">
    <div class="tablist2">
        <a class="tab active" name="NameSearch">查</br>询</a>
        <div class="tablist2_box" name="NameSearch">
            <form:form >
                <div class="row_map_ss">
                    <label>开始时间：</label>
                    <input id="beginTime" name="beginTime" value="${begintime}" class="Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 00:00:00'})">
                </div>
                <div class="row_map_ss">
                    <label>结束时间：</label>
                    <input id="endTime" name="endTime" value="${endtime}" class="Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',startDate:'%y-%M-%d 23:59:59'})">
                </div>
                <div class="row_map_ss row_map_search">
                    <a id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i class="fa fa-search"></i> 查询</a>
                </div>
                <div class="row_map_ss row_map_btn">

                    <a class="btn btn-primary btn-sm" id="start" value="开始">开始 <i class="fa fa-play"></i></a>
                    <a class="btn btn-primary btn-sm" id="pause" value="暂停">暂停 <i class="fa fa-pause"></i></a>
                    <a class="btn btn-primary btn-sm" id="resume" value="继续">继续 <i class="fa fa-play-circle-o"></i></a>
                    <a class="btn btn-primary btn-sm" id="stop" value="停止">停止 <i class="fa fa-stop"></i></a>
                </div>

            </form:form>
        </div>
    </div>
</div>
<div id="container"></div>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.14&key=1350cad6a9086d35e9478ab8c3f7afe0"></script>
<!-- UI组件库 1.0 -->
<script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
<script>

    var map = new AMap.Map("container", {
        resizeEnable: true,
        zoom: 17
    });

    // var starIcon = new AMap.Icon({image:"https://webapi.amap.com/theme/v1.3/markers/n/start.png"});
    // var endIcon  = new AMap.Icon({image:"https://webapi.amap.com/theme/v1.3/markers/n/end.png"});
    var cirleIcon = new AMap.Icon({
        size: new AMap.Size(11, 11),    // 图标尺寸
        image: '${ctxStatic}/common/images/cirle.png',  // Icon的图像
    });

    var sid = "${sid}";

    var pointArray = [];

    $(function(){

        initdata(sid);
    });

    function initdata(sid) {
        var beginTime = $("#beginTime").val();
        var endTime = $("#endTime").val();

        if(window.pathSimplifierIns){

            //通过该方法清空上次传入的轨迹
            pathSimplifierIns.setData([]);
            pointArray = [];
        }
        map.clearMap();

        var data ={
            sid : sid,
            beginTime : beginTime,
            endTime : endTime
        };
        var index = jp.loading("加载中...");
        jp.post("${ctx}/vehicle/gpsVehicle/ajax/trackPlaybackData",data,function(data){
            jp.close(index);
            if(data.success){
                var list = data.data;

                var lnglattemp;
                var count = 0;
                for(var i = 0,len=list.length; i < len; i++) {
                    var lng = list[i].lng;
                    var lat = list[i].lat;
                    //console.log("lng:"+lng+",lat:"+lat);
                    if (!lng || !lat || lng=="0" || lat=="0"){
                        continue;
                    }

                    //wgs84转国测局坐标
                    var wgs84togcj02 = coordtransform.wgs84togcj02(lng, lat);
                    console.log("转换后：" + wgs84togcj02);
                    lng = wgs84togcj02[0];
                    lat = wgs84togcj02[1];

                    var lnglat = new AMap.LngLat(lng, lat);
                    if(i==0){
                        lnglattemp = lnglat;
                    }else{
                        var distance = Math.round(lnglattemp.distance([lng,lat]));
                        console.log("lnglattemp:"+lnglattemp+",distance:"+distance);

                        if(distance<=50){
                            continue;
                        }

                        lnglattemp = lnglat;
                    }
                    count++
                    if (i == 0) {
                        marker = new AMap.Marker({
                            map: map,
                            position: lnglat, //基点位置
                            icon: "https://webapi.amap.com/theme/v1.3/markers/n/start.png"
                        });
                    }else if (i == list.length - 1) {
                        marker = new AMap.Marker({
                            map: map,
                            position: lnglat, //基点位置
                            icon: "https://webapi.amap.com/theme/v1.3/markers/n/end.png"
                        });
                    }else{
                        marker = new AMap.Marker({
                            map: map,
                            position: lnglat, //基点位置
                            icon: cirleIcon,
                            offset: new AMap.Pixel(-6, -6)
                        });
                    }

                    //构建信息窗体
                    var infoWindow = openInfo(list[i],marker);


                    pointArray.push([lng,lat]);
                }
                console.log("总记录数；"+list.length+",结果："+count);

                pathSimplifier();
            }else{
                jp.info("没有轨迹记录");
            }
        });
    }

    //在指定位置打开信息窗体
    function openInfo(obj,marker) {
        //构建信息窗体中显示的内容

        let rssi="";
        let externalVoltage="";
        let batteryVoltage="";
        //console.log("obj.externalVoltage:"+obj.externalVoltage);
        if(!!obj.externalVoltage){
            externalVoltage = obj.externalVoltage;
        }
        if(!!obj.batteryVoltage){
            batteryVoltage = obj.batteryVoltage;
        }
        if(!!obj.rssi){
            rssi = obj.rssi;
        }

        var info = [];
        info.push("<div style='line-height:1.8em;font-size:12px;'>");
        info.push("编号 ："+obj.sid);
        info.push("RSSI ："+rssi);
        info.push("速度 ："+obj.groundRate);
        info.push("外部电压 ："+externalVoltage);
        info.push("电池电压 ："+batteryVoltage);
        info.push("更新时间 ："+obj.utcDatetime);
        info.push("</div>");
        var infoWindow = new AMap.InfoWindow({
            content:  info.join("<br/>"),  //使用默认信息窗体框样式，显示信息内容
        });

        marker.on("mouseover", function(e) {
            infoWindow.open(map, e.target.getPosition());
        });
        marker.on("mouseout", function() {
            infoWindow.close();
        });

    }

    $('#search').click(function () {
        var beginTime = $('#beginTime').val();
        var endTime = $('#endTime').val();

        initdata(sid, beginTime, endTime);

    });






    var line,text;
    function computeDis(){
        var p1 = m1.getPosition();
        var p2 = m2.getPosition();
        var textPos = p1.divideBy(2).add(p2.divideBy(2));
        var distance = Math.round(p1.distance(p2));
        var path = [p1,p2];
        if(!line){
            line = new AMap.Polyline({
                map:map,
                strokeColor:'#80d8ff',
                isOutline:true,
                outlineColor:'white',
                path:path
            });
        }else{
            line.setPath(path);
        }
        if(!text){
            text = new AMap.Text({
                text:'两点相距'+distance+'米',
                position: textPos,
                map:map,
                style:{'background-color':'#29b6f6',
                    'border-color':'#e1f5fe',
                    'font-size':'12px'}
            })
        }else{
            text.setText('两点相距'+distance+'米')
            text.setPosition(textPos)
        }
    }




</script>
<script type="text/javascript">

    function pathSimplifier(){

        AMapUI.load(['ui/misc/PathSimplifier', 'lib/$'], function(PathSimplifier, $) {

            if (!PathSimplifier.supportCanvas) {
                alert('当前环境不支持 Canvas！');
                return;
            }

            //just some colors
            var colors = [
                "#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#66aa00",
                "#b82e2e", "#316395", "#994499", "#22aa99", "#aaaa11", "#6633cc", "#e67300", "#8b0707",
                "#651067", "#329262", "#5574a6", "#3b3eac"
            ];

            var pathSimplifierIns = new PathSimplifier({
                zIndex: 100,
                //autoSetFitView:false,
                map: map, //所属的地图实例

                getPath: function(pathData, pathIndex) {

                    return pathData.path;
                },
                getHoverTitle: function(pathData, pathIndex, pointIndex) {

                    // if (pointIndex >= 0) {
                    //     //point
                    //     return pathData.name + '，点：' + pointIndex + '/' + pathData.path.length;
                    // }
                    //
                    // return pathData.name + '，点数量' + pathData.path.length;
                    return null;
                },
                renderOptions: {
                    pathLineStyle: {
                        dirArrowStyle: true
                    },
                    getPathStyle: function(pathItem, zoom) {

                        var color = colors[pathItem.pathIndex % colors.length],
                            lineWidth = 4;//Math.round(4 * Math.pow(1.1, zoom - 3));
                        return {
                            pathLineStyle: {
                                strokeStyle: color,
                                lineWidth: lineWidth
                            },
                            pathLineSelectedStyle: {
                                lineWidth: lineWidth + 2
                            },
                            pathNavigatorStyle: {
                                fillStyle: color
                            }
                        };
                    }
                }
            });



            window.pathSimplifierIns = pathSimplifierIns;


            pathSimplifierIns.setData([{
                name: '轨迹',
                path: pointArray
            }]);


            function onload() {
                pathSimplifierIns.renderLater();
            }

            function onerror(e) {
                alert('图片加载失败！');
            }


            var navg1 = pathSimplifierIns.createPathNavigator(0, {
                loop: false,
                speed: 500,
                pathNavigatorStyle: {
                    width: 24,
                    height: 24,
                    //使用图片
                    content: PathSimplifier.Render.Canvas.getImageContent('http://webapi.amap.com/ui/1.0/ui/misc/PathSimplifier/examples/imgs/car.png', onload, onerror),
                    strokeStyle: null,
                    fillStyle: null,
                    //经过路径的样式
                    pathLinePassedStyle: {
                        lineWidth: 3,
                        strokeStyle: 'black',
                        dirArrowStyle: {
                            stepSpace: 15,
                            strokeStyle: 'red'
                        }
                    }
                }
            });


            map.setFitView();//根据地图上添加的覆盖物分布情况，自动缩放地图到合适的视野级别

            $("#start").click(function(){
                navg1.start();
            });

            $("#pause").click(function(){
                navg1.pause();
            });

            $("#resume").click(function(){
                navg1.resume();
            });

            $("#stop").click(function(){
                navg1.stop();
            });
            // navg1.on('move', function() {
            // 	map.setCenter(navg1.getPosition());
            // });

        });
    }
</script>
<script type="text/javascript">
    $(function(){
        changeTab();
    });
    function changeTab() {
        $(".tablist2 .tab").click(function(){
            var divname=$(this).attr("name");
            if($("div[name="+ divname +"]").is(':hidden')){
                //如果隐藏时的处理方法
                $(".tablist2 .tab").removeClass("active");
                $(".tablist2 .tab").addClass("removeactive");
                $(this).addClass("active");
                $(this).removeClass("removeactive");
                $(".tablist2_box").hide();
                $("div[name="+ divname +"]").show();

            }else{
                //如果显示时的处理方法
                $(this).removeClass("active");
                $(this).addClass("removeactive");
                $("div[name="+ divname +"]").hide();
            }


        });
    }
</script>
</body>
</html>
