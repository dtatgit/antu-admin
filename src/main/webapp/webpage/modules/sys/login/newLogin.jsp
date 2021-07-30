<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!-- _login_page_ --><!--登录超时标记 勿删-->
<html>
<head>
    <meta name="decorator" content="ani"/>
    <link href="${ctxStatic}/common/css/app-login.css" rel="stylesheet">
    <title>${fns:getConfig('productName')} 登录</title>
    <script>
        if (window.top !== window.self) {
            window.top.location = window.location;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#loginForm").validate({
                rules: {
                    validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
                },
                messages: {
                    username: {required: "请填写用户名."},password: {required: "请填写密码."},
                    validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
                },
                errorLabelContainer: "#messageBox",
                errorPlacement: function(error, element) {
                    error.appendTo($("#loginError").parent());
                }
            });
        });

        // 如果在框架或在对话框中，则弹出提示并跳转到首页
        if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0){
            alert('未登录或登录超时。请重新登录，谢谢！');
            top.location = "${ctx}";
        }
    </script>
</head>

<body>
	<div class="login-page">
		<div class="login-head">
			<div class="width1330">
				<div class="logo-left"><img src="../static/common/images/logo.png" />天天安途后台管理平台</div>
				<img  class="logo-right" src="${systemConfig.rightLogo}" />
			</div>
		</div>
		<div class="row width1330 login-main">
			<sys:message content="${message}" showType="1"/>
			<div class="col-xs-12 col-md-6 logo-content-leftimg rotateX">
				<%-- <img src="${ctxStatic}/common/images/product.png" /> --%>
			</div>
			<div class="col-xs-12 col-md-6 login-content animated flipInX">
			 <div class="login-content-form">
				<img  class="img-circle" src="../static/common/images/logo.png" />
				<h1>LOGIN</h1>
				<form id="loginForm" role="form" action="${ctx}/login" method="post">
					<div class="form-content">
						<div class="form-group">
							<label class="labtitle"><img src="${ctxStatic}/common/images/user_icon.png"  /></label>
							<input type="text" id="username" name="username" class="form-control input-underline input-lg required"  value="" placeholder="用户名">
						</div>

						<div class="form-group">
							<label class="labtitle"><img src="${ctxStatic}/common/images/pwd_icon.png"  /></label>
							<input type="password" id="password" name="password" value="" class="form-control input-underline input-lg required" placeholder="密码">
						</div>
						<c:if test="${isValidateCodeLogin}">
						<div class="form-group  text-muted">
							<label class="labtitle yzmlabel"><img src="${ctxStatic}/common/images/yzm_icon.png"  /><span id="yamfont">验证码</span></label>
							<sys:validateCode name="validateCode"/>
						</div>
						</c:if>
						<div class="form-group">
						<label class="inline">
								<input  type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''} class="ace" />
								<span class="lbl"> 记住我</span>
						</label>
						</div>
					</div>
					<input type="submit" class="progress-login2"  value="登录">
					<label class="version">系统版本：1.0</label>
				</form>
			 </div>
			</div>
		  </div>
	    <%-- <div class="foot">客服电话：17772280811  |  Copyright 天天安途（北京）信息技术有限公司<br/>京ICP备15045921</div> --%>
	</div>

	<script>
        $(function(){
                $('.theme-picker').click(function() {
                    changeTheme($(this).attr('data-theme'));
                });

        });

        function changeTheme(theme) {
            $('<link>')
            .appendTo('head')
            .attr({type : 'text/css', rel : 'stylesheet'})
            .attr('href', '${ctxStatic}/common/css/app-'+theme+'.css');
            //$.get('api/change-theme?theme='+theme);
             $.get('${pageContext.request.contextPath}/theme/'+theme+'?url='+window.top.location.href,function(result){  });
        }
    </script>
    <style>
        li.color-picker i {
            font-size: 24px;
            line-height: 30px;
        }
        .red-base {
            color: #D24D57;
        }
        .blue-base {
            color: #3CA2E0;
        }
        .green-base {
            color: #27ae60;
        }
        .purple-base {
            color: #957BBD;
        }
        .midnight-blue-base {
            color: #2c3e50;
        }
        .lynch-base {
            color: #6C7A89;
        }
    </style>
</body>
</html>