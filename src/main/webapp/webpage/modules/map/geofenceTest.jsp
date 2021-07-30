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
    <script src="${ctxStatic}/plugin/layui/layer/layer.js" type="text/javascript"></script>

    <style>
        html,
        body,
        #container {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<div id="container"></div>
<div class="button-group">
    <input type="button" class="button" value="开始编辑折线" onClick="editor.startEditLine()"/>
    <input type="button" class="button" value="结束编辑折线" onClick="editor.closeEditLine()"/>
    <input type="button" class="button" value="开始编辑多边形" onClick="editor.startEditPolygon()"/>
    <input type="button" class="button" value="结束编辑多边形" onClick="editor.closeEditPolygon()"/>
    <input type="button" class="button" value="开始编辑圆" onClick="editor.startEditCircle()"/>
    <input type="button" class="button" value="结束编辑圆" onClick="editor.closeEditCircle()"/>
</div>
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=1350cad6a9086d35e9478ab8c3f7afe0&plugin=AMap.PolyEditor,AMap.CircleEditor"></script>
<script>
    var datas;
    pullUpAction();

    var editorTool, map = new AMap.Map("container", {
        resizeEnable: true,
        //center: [116.403322, 39.900255],//地图中心点
        zoom: 13 //地图显示的缩放级别
    });
    //在地图上绘制折线
    var editor={};
    editor._line=(function(){
        var lineArr = [
            [116.368904, 39.913423],
            [116.382122, 39.901176],
            [116.387271, 39.912501],
            [116.388258, 39.904600]
        ];
        return new AMap.Polyline({
            map: map,
            path: lineArr,
            strokeColor: "#FF33FF",//线颜色
            strokeOpacity: 1,//线透明度
            strokeWeight: 3,//线宽
            strokeStyle: "solid"//线样式
        });
    })();
    editor._polygon=(function(){
        var arr = [ //构建多边形经纬度坐标数组
            [116.403322,39.920255],
            [116.410703,39.897555],
            [116.402292,39.892353],
            [116.389846,39.891365]
        ]
        return new AMap.Polygon({
            map: map,
            path: datas,
            strokeColor: "#0000ff",
            strokeOpacity: 1,
            strokeWeight: 3,
            fillColor: "#f5deb3",
            fillOpacity: 0.35
        });
    })();
    editor._circle=(function(){
        var circle = new AMap.Circle({
            center: [116.433322, 39.900255],// 圆心位置
            radius: 1000, //半径
            strokeColor: "#F33", //线颜色
            strokeOpacity: 1, //线透明度
            strokeWeight: 3, //线粗细度
            fillColor: "#ee2200", //填充颜色
            fillOpacity: 0.35//填充透明度
        });
        circle.setMap(map);
        return circle;
    })();
    map.setFitView();
    editor._lineEditor= new AMap.PolyEditor(map, editor._line);
    editor._polygonEditor= new AMap.PolyEditor(map, editor._polygon);
    editor._circleEditor= new AMap.CircleEditor(map, editor._circle);

    editor.startEditLine=function(){
        editor._lineEditor.open();
    }
    editor.closeEditLine=function(){
        editor._lineEditor.close();
    }

    editor.startEditPolygon=function(){
        editor._polygonEditor.open();
    }
    editor.closeEditPolygon=function(){
        editor._polygonEditor.close();
    }

    editor.startEditCircle=function(){
        editor._circleEditor.open();
    }
    editor.closeEditCircle=function(){
        editor._circleEditor.close();
    }
    //    AMap.event.addListener(editor._polygonEditor,"end",function(type,target){
    // 回头看看我们用过的，画图时
    //  	alert(type);
    //	});
    AMap.event.addListener(editor._polygonEditor,'end',function(res){
        alert(res.target);
    });



    function pullUpAction () {



        var param = {"pagenum":1,"infos":2};
        $.ajax({
            //url:"/spring_mvc/api/peizhiinfo", //后台处理程序
            url:"getPoly", //后台处理程序
            type:'post',         //数据发送方式
            dataType: 'json',
            data:param,
            async: true,
            success:function(data){
                datas=data;
                createPolygon(datas);
                //  var result = "" ;
                //  var i=0;
                //  $(data).each(function(){
                //  var checker = $(this)[0];
                //  result += "<div  class='weui-form-preview__item' id='"+checker.typeimg+"'> <label class='weui-form-preview__label'>"+checker.typename+"</label>"+
                //                              "<span  class='weui-form-preview__value' style='color:#"+checker.typecolor+"'>"+checker.typevalue+"</span></div>";
                //    i++;
                //	  });

            }
        });


    }
    //创建一个多边形对象
    function createPolygon(arr){
        var polygon = new AMap.Polygon({
            map: map,
            path: arr,
            strokeColor: "#00ffff",
            strokeOpacity: 1,
            strokeWeight: 3,
            fillColor: "#f5deb3",
            fillOpacity: 0.35
        });
        return polygon;
    }
    //创建一个多边形对象的编辑类对象
    function createEditor(polygon){
        var polygonEditor = new AMap.PolyEditor(map, polygon);
        polygonEditor.open();
        AMap.event.addListener(polygonEditor,'end',polygonEnd);
        return polygonEditor;
    }
    //编辑结束事件
    function polygonEnd(res){
        resPolygon.push(res.target);
        alert(resPolygon[resNum].contains([116.386328, 39.913818]));
        appendHideHtml(resNum,res.target.getPath());

        resNum++;
        init();
    }



</script>
</body>
</html>
