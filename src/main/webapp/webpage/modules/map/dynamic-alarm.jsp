<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <!-- 引入 echarts.js -->
    <%@ include file="/webpage/include/echarts.jsp"%>
    <title>警报信息</title>

    <script src="${ctxStatic}/plugin/layui/sockjs.js"></script><!-- 如果浏览器不支持socktjs，添加支持 -->

    <script src="${ctxStatic}/common/js/jquery-3.3.1.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/plugin/layui/layer/layer.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/js/moment.js" type="text/javascript"></script>


    <script type="text/javascript">
        var sid = '${sid}';
        var webSocket = null;
        (function() {
            var host = window.document.location.host;
            var pathName = window.document.location.pathname;
            var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
            if(projectName=="/a"){
                projectName = "";
            }
            var wsServer = "ws://" + host + projectName;

            console.log("wsServer:"+wsServer);

            if ('WebSocket' in window || 'MozWebSocket' in window) {
                //webSocket = new WebSocket("ws://123.58.241.225:8080/alpaca/smokeSocketServer?connectName=manage_smoke_"+tagId);
                webSocket = new WebSocket(wsServer+"/gpsModuleSocketServer?connectName=gps_manager_alarm_"+sid);
            } else {
                webSocket = new SockJS(wsServer+"/sockjs/gpsModuleSocketServer");
            }

            webSocket.onerror = function(event) {
                jp.error("websockt连接发生错误，请刷新页面重试!")
            };

            //连接成功建立的回调方法
            webSocket.onopen = function () {
                console.log("连接成功");
            };

            // 接收到消息的回调方法
            webSocket.onmessage = function(event) {
                var res=event.data;
                console.log("res:"+res);
                var jsonObj = JSON.parse(res);
                var x = jsonObj.x;
                var y = jsonObj.y;
                var z = jsonObj.z;

                var sqrt = Math.sqrt(x*x+y*y+z*z);

                //console.log("sqrt:"+sqrt);

                if(dataX.length>60){
                    dataX.shift();
                }
                if(dataY.length>60){
                    dataY.shift();
                }
                if(dataZ.length>60){
                    dataZ.shift();
                }
                if(dataSqrt.length>60){
                    dataSqrt.shift();
                }

                dataX.push(buildData(x));
                dataY.push(buildData(y));
                dataZ.push(buildData(z));
                dataSqrt.push(buildData(sqrt));

                myChart.setOption({
                    series: [{
                        data: dataX
                    },
                        {
                            data: dataY
                        },
                        {
                            data: dataZ
                        },
                        {
                            data: dataSqrt
                        }
                    ]
                });

            };

            webSocket.onclose = function()
            {
                // 关闭 websocket
                console.log("连接断开");
            };
        })(jQuery);

        //发送信息方法
        function sendHostid(hostid) {
            webSocket.send("_hostid_"+hostid);
        };

        function paizhao2() {
            var hostid = $("#hostid2").val();
            var tagid = $("#tagid2").val();
            if(hostid==''||hostid==''){
                alert("主机ID不能为空");
                return;
            }
            jp.loading();
            webSocket.send(hostid+"_paizhao_"+tagid);
        }

    </script>

</head>
<body>

<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 100%;height: 100%"></div>
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
    window.onresize = myChart.resize;

    function randomData() {
        var modTine = moment().format('YYYY-MM-DD HH:mm:ss');//new Date(+now + oneDay);  //让当前日期加上一天，也就是每次执行这个函数的时候会+1天
        //console.log("modTine:"+modTine);
        value = value + Math.random() * 21 - 10;   //生成一个随机的数值
        return {
            name: modTine, //时间转字符
            value: [
                //[now.getFullYear(), now.getMonth() + 1, now.getDate()].join('/'),  //生成日期的格式，例如：1998/1/2
                modTine,
                Math.round(value)
            ]
        }
    }
    var dataX = [];
    var dataY = [];
    var dataZ = [];
    var dataSqrt = [];
    function buildData(par) {
        var nowTime = moment().format('YYYY-MM-DD HH:mm:ss');
        return {
            name: nowTime, //时间转字符
            value: [
                nowTime,
                Math.round(par)
            ]
        }
    }


    var data = [];
    var value = 100;//Math.random() * 1000; //生成一个随机的数值
    for (var i = 0; i < 100; i++) {
        data.push(randomData()); //循环执行randomData,并将结果放入data数组
    }

    option = {
        title: {
            text: 'GPS警报动态数据'
        },
        tooltip: {
            trigger: 'axis',
            formatter: function (params) {
                params = params[0];
                var date = new Date(params.name);
                return date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear() + ' : ' + params.value[1];
            },
            axisPointer: {
                animation: false
            }
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            type: 'value',
            boundaryGap: [0, '100%'],
            splitLine: {
                show: false
            }
        },
        series: [{
            name: 'x',
            type: 'line',
            showSymbol: false,
            hoverAnimation: false,
            data: dataX
        },
            {
                name: 'y',
                type: 'line',
                showSymbol: false,
                hoverAnimation: false,
                data: dataY
            },
            {
                name: 'z',
                type: 'line',
                showSymbol: false,
                hoverAnimation: false,
                data: dataZ
            },
            {
                name: 's',
                type: 'line',
                showSymbol: false,
                hoverAnimation: false,
                data: dataSqrt
            }
        ]
    };
    myChart.setOption(option);
    // setInterval(function () {
    //
    //
    //         data.shift();
    //         data.push(randomData());
    //     for (var i = 0; i < data.length; i++) {
    //
    //         //console.log("data:"+i+"->"+data[i].value);
    //         console.log("data:"+i+"->"+data[i].name+"-->"+data[i].value);
    //     }
    //
    //     myChart.setOption(option);
    //     myChart.setOption({
    //         series: [{
    //             data: data
    //         }]
    //     });
    // }, 1000);

</script>

</body>
</html>
