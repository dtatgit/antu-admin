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

        var resultData;

        function save(setFenceDatas) {

            var jsonStr = "";
            if(!!resultData){
                jsonStr = JSON.stringify(resultData);
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
<div class="input-card" style="width: 200px">
    <h4 style="margin-bottom: 10px; font-weight: 600">绘制覆盖物</h4>
    <button class="btn" onclick="drawCircle()" style="margin-bottom: 5px">绘制圆形</button>
    <button class="btn" onclick="openditor()" style="margin-bottom: 5px">开始编辑</button>
    <button class="btn" onclick="closeEdit()" style="margin-bottom: 5px">结束编辑</button>
</div>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=1350cad6a9086d35e9478ab8c3f7afe0&plugin=AMap.MouseTool,AMap.CircleEditor"></script>

<script>
    //定义地图画图工具  中心点等
    var map = new AMap.Map("container", {
        resizeEnable: true,
        center: [115.48,38.85],//地图中心点
        zoom: 13 //地图显示的缩放级别
    });

    var mouseTool = new AMap.MouseTool(map);


    var num = 0;
    function drawCircle () {
        if(num==0){
            mouseTool.circle({
                strokeColor: "#FF33FF",
                strokeOpacity: 1,
                strokeWeight: 6,
                strokeOpacity: 0.2,
                fillColor: '#1791fc',
                fillOpacity: 0.4,
                strokeStyle: 'solid',
                // 线样式还支持 'dashed'
                // strokeDasharray: [30,10],
            })
        }
        num++;
    }

    mouseTool.on('draw', function(event) {
        // event.obj 为绘制出来的覆盖物对象
        console.log('覆盖物对象绘制完成')

        createEditor2(event.obj);

        mouseTool.close();
    });

    var circleEditor;
    function createEditor2(circle) {
        circleEditor = new AMap.CircleEditor(map, circle)

        circleEditor.on('move', function(event) {
            console.log('触发事件：move')
        })

        circleEditor.on('adjust', function(event) {
            console.log('触发事件：adjust')
        })

        circleEditor.on('end', function(event) {
            console.log('触发事件： end')
            // event.target 即为编辑后的圆形对象

            lnglatArr.length = 0;

            let center = event.target.getCenter();
            let radius = event.target.getRadius();

            var circleData = {
                center:center,
                radius:radius
            };

            resultData = circleData;

        })

        circleEditor.open();
    }

    function openditor() {
        circleEditor.open();
    }

    function closeEdit() {
        circleEditor.close();
    }

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
    //init();
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
        console.log("sourceData:"+sourceData);
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
