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
    <script src="${ctxStatic}/common/js/moment.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/table2excel.js" type="text/javascript"></script>
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
                    <a id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i class="fa fa-search"></i> 查询</a>&nbsp;
                    <a id="export" class="btn btn-primary btn-rounded  btn-bordered btn-sm" style="width: 100%"><i class="fa fa-search"></i> 导出</a>
                    <%--<a id="print-click">超链接_导出表格</a>--%>
                    <%--<input type="button" onclick="download()" value="函数_导出表格" class="btn btn-primary btn-rounded  btn-bordered btn-sm" />--%>
                    <%--<input type="button" onclick="printout()" value="打印"></input>--%>
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
<div id="divTemp" style="display: none;">
    <table id="print-content" border="1" cellpadding="0" cellspacing="0" style='border-collapse:collapse;table-layout:fixed;'>
        <colgroup>
            <col width="80 ">
            <col width="150 ">
            <col>
            <col width="150 ">
            <col>
            <col width="80 ">
            <col width="80 ">
        <%--</colgroup>--%>
        <%--<tr height="20" style="text-align: center;font-size:18px">--%>
            <%--<td colspan="7">会签单</td>--%>
        <%--</tr>--%>
        <tr height="20" style="text-align: center;font-size:14px">
            <td>序号</td>
            <td>开始时间</td>
            <td>开始位置</td>
            <td>结束时间</td>
            <td>结束位置</td>
            <td>车速</td>
            <td>方向</td>
        </tr>
        <%--<tr height="20" style="text-align: center;font-size:14px">--%>
            <%--<td>名称</td>--%>
            <%--<td colspan="2">自动获取</td>--%>
            <%--<td>编号</td>--%>
            <%--<td colspan="3">自动获取</td>--%>
        <%--</tr>--%>
        <%--<tr height="20" style="text-align: center;font-size:14px">--%>
            <%--<td>主持</td>--%>
            <%--<td colspan="2">自动获取</td>--%>
            <%--<td>类型</td>--%>
            <%--<td colspan="3">自动获取</td>--%>
        <%--</tr>--%>
        <%--<tr height="20" style="text-align: center;font-size:14px">--%>
            <%--<td>人</td>--%>
            <%--<td colspan="2">自动获取</td>--%>
            <%--<td>日期</td>--%>
            <%--<td colspan="3">自动获取</td>--%>
        <%--</tr>--%>
        <%--<tr height="100" style="text-align: center;font-size:14px">--%>
            <%--<td rowspan="5">内容</td>--%>
            <%--<td colspan="6" rowspan="5">自动获取</td>--%>
        <%--</tr>--%>
        <%--<tr/>--%>
        <%--<tr/>--%>
        <%--<tr/>--%>
        <%--<tr/>--%>
        <%--<tr height="20" style="text-align: center;font-size:14px">--%>
            <%--<td>备注</td>--%>
            <%--<td colspan="6">自动获取</td>--%>
        <%--</tr>--%>
        <%--<tr height="24" style="text-align: center;font-size:16px">--%>
            <%--<td colspan="7">意见</td>--%>
        <%--</tr>--%>
        <%--<tr height="24" style="text-align: center;font-size:14px">--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
            <%--<td>2020-03-09 19:05:53</td>--%>
        <%--</tr>--%>
        <%--<tr height="20" style="text-align: center;font-size:14px">--%>
            <%--<td>1</td>--%>
            <%--<td>顾</td>--%>
            <%--<td>办公室</td>--%>
            <%--<td>同意！</td>--%>
            <%--<td>2018/5/14 15:21</td>--%>
            <%--<td></td>--%>
            <%--<td>已提交</td>--%>
        <%--</tr>--%>
    </table>
</div>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.14&key=1350cad6a9086d35e9478ab8c3f7afe0&plugin=AMap.Geocoder"></script>
<!-- UI组件库 1.0 -->
<script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
<script>

    //判断是否IE浏览器
    function isIE() {
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            return true;
        } else {
            return false;
        }
    }

    // // 使用outerHTML属性获取整个table元素的HTML代码（包括<table>标签），然后包装成一个完整的HTML文档，设置charset为urf-8以防止中文乱码
    // var html = "<html><head><meta charset='utf-8' /></head><body>" + document.getElementById("print-content").outerHTML + "</body></html>";
    // // 实例化一个Blob对象，其构造函数的第一个参数是包含文件内容的数组，第二个参数是包含文件类型属性的对象
    // var blob = new Blob([html], {
    //     type: "application/vnd.ms-excel"
    // });
    // var a = document.getElementById("print-click");
    // // 利用URL.createObjectURL()方法为a元素生成blob URL
    // a.href = URL.createObjectURL(blob);
    // // 设置文件名，目前只有Chrome和FireFox支持此属性
    // a.download = "会签单.xls";

    Table2Excel.extend(function(cell, cellText) {
        // {HTMLTableCellElement} cell - The current cell.
        // {string} cellText - The inner text of the current cell.
        // 不要给我转乱七八糟的格式，就是文本输出就行，
        // 转格式转的乱七八糟的
        // cell should be described by this type handler
        return {
            t: 'text',
            v: cellText,
        };

        // skip and run next handler
        return null;
    });

    function download() {


        let tt = jp.loading("正在下载中...");


        //延迟50ms 在执行， 不然不弹层
        setTimeout( function(){

            for(let i=0;i<resultDataArr.length;i++){
                //console.log(resultDataArr[i].lng+"-->"+resultDataArr[i].lat);

                let temp = "<tr height=\"24\" style=\"text-align: center;font-size:14px\">";

                let dtemp = resultDataArr[i];
                let endTime;
                let address1 = '';//result.regeocodes[i].formattedAddress;
                $.ajax({
                    type: "post",
                    url: "${ctx}/vehicle/gpsVehicle/ajax/getAddress",
                    data: {
                        lng: dtemp.lng,
                        lat: dtemp.lat
                    },
                    async: false,
                    success(v) {
                        console.log("v:"+JSON.stringify(v));
                        address1 = v.data;//v.regeocode.formatted_address;
                        //console.log(dtemp.lng+","+dtemp.lat, "：", v.regeocode.formatted_address);
                    }
                });


                let address2;
                if(i == resultDataArr.length-1){
                    endTime = dtemp.beginTime;
                    address2 = address1;
                }else{
                    let dtemp2 = resultDataArr[i+1];
                    endTime = dtemp2.beginTime;
                    address2 = address1;//result.regeocodes[i+1].formattedAddress;
                }
                console.log("dtemp.beginTime:"+dtemp.beginTime);
                temp += "<td>"+(i+1)+"</td>";
                temp += "<td>"+dtemp.beginTime+"</td>";
                temp += "<td>"+address1+"</td>";
                temp += "<td>"+endTime+"</td>";
                temp += "<td>"+address2+"</td>";
                temp += "<td>"+dtemp.speed+"</td>";
                temp += "<td>"+dtemp.direction+"</td>";

                temp += "</tr>";
                $("#print-content").append(temp);
            }

            jp.close(tt);
            // // 使用outerHTML属性获取整个table元素的HTML代码（包括<table>标签），然后包装成一个完整的HTML文档，设置charset为urf-8以防止中文乱码
            // var html = "<html><head><meta charset='utf-8' /></head><body>" + document.getElementById("print-content").outerHTML + "</body></html>";
            // // 实例化一个Blob对象，其构造函数的第一个参数是包含文件内容的数组，第二个参数是包含文件类型属性的对象
            // var blob = new Blob([html], {
            //     type: "application/vnd.ms-excel"
            // });
            // var fileName = "轨迹数据.xls";
            // if(isIE()){
            //     window.navigator.msSaveOrOpenBlob(blob,fileName);
            // }else{
            //     var oa = document.createElement('a');
            //     oa.href = URL.createObjectURL(blob);
            //     oa.download = fileName;
            //     document.body.appendChild(oa);
            //     oa.click();
            //     document.body.removeChild(oa);
            // }

            // $("#print-content").table2excel({
            //     exclude: ".noExl",
            //     name: "Excel Document Name.xlsx",
            //     filename: "myFileName" + new Date().toISOString().replace(/[\-\:\.]/g, "") + ".xls",
            //     exclude_img: true,
            //     exclude_links: true,
            //     exclude_inputs: true,
            //     preserveColors: false
            // });

            var table2excel = new Table2Excel({
                defaultFileName:"轨迹数据" + new Date().toISOString().replace(/[\-\:\.]/g, "") + ".xls"
            });
            $("#divTemp").show();  //style="display: none;" 的 导出内容为空，所以这里先显示，后隐藏
            table2excel.export(document.getElementById("print-content"));
            $("#divTemp").hide();


        }, 20);//延迟20毫秒
    };
    //打印具体实现代码
    function printout() {
        debugger;
        var newWindow;
        //打开一个新的窗口
        newWindow = window.open();
        // 是新窗口获得焦点
        newWindow.focus();
        //保存写入内容
        var newContent = "<html><head><meta charset='utf-8'/><title>打印</title></head><body>"
        newContent += document.getElementById("print-content").outerHTML;
        newContent += "</body></html>"
        // 将HTML代码写入新窗口中
        newWindow.document.write(newContent);
        newWindow.print();
        // close layout stream
        newWindow.document.close();
        //关闭打开的临时窗口
        newWindow.close();
        return false;
    };





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

    var devId = "${devId}";

    var resultDataArr = [] ; //记录查询的结果

    var pointArray = [];

    AMapUI.load(['ui/misc/PathSimplifier', 'lib/$'], function(PathSimplifier, $) {

        if (!PathSimplifier.supportCanvas) {
            alert('当前环境不支持 Canvas！');
            return;
        }
        PathSimplifier = PathSimplifier;
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

        initdata(devId);

        // pathSimplifierIns.setData([{
        //     name: '轨迹',
        //     path: pointArray
        // }]);


        function onload() {
            pathSimplifierIns.renderLater();
        }

        function onerror(e) {
            alert('图片加载失败！');
        }


        // var navg1 = pathSimplifierIns.createPathNavigator(0, {
        //     loop: false,
        //     speed: 500,
        //     pathNavigatorStyle: {
        //         width: 24,
        //         height: 24,
        //         //使用图片
        //         content: PathSimplifier.Render.Canvas.getImageContent('http://webapi.amap.com/ui/1.0/ui/misc/PathSimplifier/examples/imgs/car.png', onload, onerror),
        //         strokeStyle: null,
        //         fillStyle: null,
        //         //经过路径的样式
        //         pathLinePassedStyle: {
        //             lineWidth: 3,
        //             strokeStyle: 'black',
        //             dirArrowStyle: {
        //                 stepSpace: 15,
        //                 strokeStyle: 'red'
        //             }
        //         }
        //     }
        // });


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

        $('#search').click(function () {
            var beginTime = $('#beginTime').val();
            var endTime = $('#endTime').val();

            initdata(devId, beginTime, endTime);

        });

        $('#export').click(function () {
            download();
        });

        var navg1;
        function initdata(devId) {
            var beginTime = $("#beginTime").val();
            var endTime = $("#endTime").val();

            if(window.pathSimplifierIns){

                //通过该方法清空上次传入的轨迹
                pathSimplifierIns.setData([]);
                pointArray = [];
            }
            map.clearMap();

            var data ={
                devId : devId,
                beginTime : beginTime,
                endTime : endTime
            };
            var index = jp.loading("加载中...");
            jp.post("${ctx}/vehicle/gpsVehicle/ajax/trackPlaybackData",data,function(data){
                jp.close(index);
                if(data.success){
                    var list = data.data;

                    let tempComp = 50;
                    if(list.length > 2000){
                        tempComp = 100;
                    }else if(list.length>3000){
                        tempComp = 150;
                    }else if(list.length>4000){
                        tempComp = 200;
                    }
                    var lnglattemp;
                    var count = 0;
                    let itemtemp,endlnglattemp;
                    for(var i = 0,len=list.length; i < len; i++) {
                        var lng = list[i].lng;
                        var lat = list[i].lat;
                        //console.log("lng:"+lng+",lat:"+lat);
                        if (!lng || !lat || lng<-180 || lng > 180 || lat<-90 || lat > 90){
                            continue;
                        }

                        //wgs84转国测局坐标
                        var wgs84togcj02 = coordtransform.wgs84togcj02(lng, lat);
                        //console.log("转换后：" + wgs84togcj02);
                        lng = wgs84togcj02[0];
                        lat = wgs84togcj02[1];

                        var lnglat = new AMap.LngLat(lng, lat);
                        if(i==0){
                            lnglattemp = lnglat;
                        }else{
                            var distance = Math.round(lnglattemp.distance([lng,lat]));
                            //console.log("lnglattemp:"+lnglattemp+",distance:"+distance);

                            if(distance<=tempComp){  //两个点小于20米则不记录
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

                        //临时记录最后一项值和点数据
                        itemtemp = list[i];
                        endlnglattemp = lnglat;

                        //重新封装成一个数据，供后面导出
                        let course = list[i].course;
                        let direction = '';
                        if(course>=0 && course<10){
                            direction = "北";
                        }else if(course>=10 && course<=80){
                            direction = "东北";
                        }else if(course>80 && course<100){
                            direction = "东";
                        }else if(course>=100 && course<=170){
                            direction = "东南";
                        }else if(course>170 && course<190){
                            direction = "南";
                        }else if(course>=190 && course<=260){
                            direction = "西南";
                        }else if(course>260 && course<280){
                            direction = "西";
                        }else if(course>=280 && course<=350){
                            direction = "西北";
                        }else if(course>350 && course<=360){
                            direction = "北";
                        }

                        let temp = {
                            id:i,
                            beginTime:list[i].utcDatetime,
                            beginLocation:'',
                            endTime:'',
                            endLocation:'',
                            speed:list[i].speed,
                            direction:direction,
                            lat : list[i].lat,
                            lng : list[i].lng,
                        };
                        resultDataArr.push(temp);
                    }

                    //最后一个点加end图标
                    let marker11 = new AMap.Marker({
                        map: map,
                        position: endlnglattemp, //基点位置
                        icon: "https://webapi.amap.com/theme/v1.3/markers/n/end.png"
                    });
                    openInfo(itemtemp,marker11);



                    //displayData(pointArray);
                    pathSimplifierIns.setData([{
                        name: '轨迹',
                        path: pointArray
                    }]);

                    navg1 = pathSimplifierIns.createPathNavigator(0, {
                        loop: false,
                        speed: 50,
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
                    console.log("总记录数；"+list.length+",结果："+count);
                }else{
                    jp.info(data.msg);
                }
            });
        }

    });


    //根据坐标获取地址
    var geocoder;
    function regeoCode() {
        if(!geocoder){
            geocoder = new AMap.Geocoder({
                city: "010", //城市设为北京，默认：“全国”
                radius: 1000 //范围，默认：500
            });
        }
        geocoder.getAddress(pointArray, function(status, result) {
            var address = []

            if (status === 'complete'&&result.regeocodes.length) {

                var str = '序号,开始时间,开始位置,结束时间,结束位置,车速,方向\n';
                console.log('ss:'+result.regeocodes.length);
                for(let i=0;i<resultDataArr.length;i++){
                    console.log(resultDataArr[i].lng+"-->"+resultDataArr[i].lat);
                    let dtemp = resultDataArr[i];
                    let endTime;
                    let address1 = '';//result.regeocodes[i].formattedAddress;
                    let address2;
                    if(i == resultDataArr.length-1){
                        endTime = dtemp.beginTime;
                        address2 = address1;
                    }else{
                        let dtemp2 = resultDataArr[i+1];
                        endTime = dtemp2.beginTime;
                        address2 = '';//result.regeocodes[i+1].formattedAddress;
                    }
                    str += (i+1).toString()+','+dtemp.beginTime+'\t,'+address1+','+endTime+'\t,'+address2+','+dtemp.speed+','+dtemp.direction+',\n'
                }
                var blob = new Blob([str], {type: "text/plain;charset=utf-8"});
                //解决中文乱码问题
                blob =  new Blob([String.fromCharCode(0xFEFF), blob], {type: blob.type});
                let object_url = window.URL.createObjectURL(blob);
                var link = document.createElement("a");
                link.href = object_url;
                link.download =  "导出.csv";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);

                // for(var i=0;i< result.regeocodes.length;i+=1){
                //     console.log(result.regeocodes[i].formattedAddress);
                //     //document.getElementById("address"+(i+1)).value = result.regeocodes[i].formattedAddress
                // }

            }else{
                alert(JSON.stringify(result))
            }
        });
    }


    //pathSimplifier();

    $(function(){

        //initdata(devId);
    });



    function displayData(pointArray) {
        pathSimplifierIns.setData([{
            name: '轨迹',
            path: pointArray
        }]);

        // //创建一个巡航器
        // var navg0 = pathSimplifierIns.createPathNavigator(0, {
        //     loop: true, //循环播放
        //     speed: 500000
        // });
        //
        // navg0.start();
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
        info.push("编号 ："+obj.devId);
        // info.push("RSSI ："+rssi);
        info.push("速度 ："+obj.speed);
        // info.push("外部电压 ："+externalVoltage);
        // info.push("电池电压 ："+batteryVoltage);
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
