<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>文章管理</title>
	<meta name="decorator" content="ani"/>
	<!-- SUMMERNOTE -->
	<%@include file="/webpage/include/summernote.jsp" %>
	<script type="text/javascript">

		$(document).ready(function() {
			jp.ajaxForm("#inputForm",function(data){
				if(data.success){
				    jp.success(data.msg);
					jp.go("${ctx}/article/tArticle");
				}else{
				    jp.error(data.msg);
				    $("#inputForm").find("button:submit").button("reset");
				}
			});

				//富文本初始化
			$('#articleContent').summernote({
				height: 300,                
                lang: 'zh-CN',
                callbacks: {
                    onChange: function(contents, $editable) {
                        $("input[name='articleContent']").val($('#articleContent').summernote('code'));//取富文本的值
                    }
                }
            });
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content">				
<div class="row">
	<div class="col-md-12">
	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title"> 
				<a class="panelButton" href="${ctx}/article/tArticle"><i class="ti-angle-left"></i> 返回</a>
			</h3>
		</div>
		<div class="panel-body">
		<form:form id="inputForm" modelAttribute="tArticle" action="${ctx}/article/tArticle/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
				<div class="form-group">
					<label class="col-sm-2 control-label"><font color="red">*</font>分类：</label>
					<div class="col-sm-10">
						<sys:treeselect id="cat" name="cat.id" value="${tArticle.cat.id}" labelName="cat.name" labelValue="${tArticle.cat.name}"
							title="分类" url="/article/tArticleCat/treeData" extId="${tArticle.id}" cssClass="form-control required" allowClear="true"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label"><font color="red">*</font>文章标题：</label>
					<div class="col-sm-10">
						<form:input path="articleTitle" htmlEscape="false"    class="form-control required"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label"><font color="red">*</font>简介：</label>
					<div class="col-sm-10">
						<form:textarea path="remarks" htmlEscape="false" rows="4"    class="form-control required"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">封面图片：</label>
					<div class="col-sm-10">
						<sys:fileUpload path="coverImg"  value="${tArticle.coverImg}" fileNumLimit="1" type="images" uploadPath="/article/tArticle" outSidePath="true"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">文章内容：</label>
					<div class="col-sm-10">
                        <input type="hidden" name="articleContent" value=" ${tArticle.articleContent}"/>
						<div id="articleContent">
                          ${fns:unescapeHtml(tArticle.articleContent)}
                        </div>
					</div>
				</div>
		<c:if test="${mode == 'add' || mode=='edit'}">
				<div class="col-lg-3"></div>
		        <div class="col-lg-6">
		             <div class="form-group text-center">
		                 <div>
		                     <button class="btn btn-primary btn-block btn-lg btn-parsley" data-loading-text="正在提交...">提 交</button>
		                 </div>
		             </div>
		        </div>
		</c:if>
		</form:form>
		</div>				
	</div>
	</div>
</div>
</div>
</body>
</html>