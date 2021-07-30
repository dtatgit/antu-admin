<%@ page contentType="text/html;charset=UTF-8" %>
<script>
	    var $tArticleCatTreeTable=null;  
		$(document).ready(function() {
			$tArticleCatTreeTable=$('#tArticleCatTreeTable').treeTable({  
		    	   theme:'vsStyle',	           
					expandLevel : 2,
					column:0,
					checkbox: false,
		            url:'${ctx}/article/tArticleCat/getChildren?parentId=',  
		            callback:function(item) { 
		            	 var treeTableTpl= $("#tArticleCatTreeTableTpl").html();
		            	 item.dict = {};

		            	 var result = laytpl(treeTableTpl).render({
								  row: item
							});
		                return result;                   
		            },  
		            beforeClick: function($tArticleCatTreeTable, id) { 
		                //异步获取数据 这里模拟替换处理  
		                $tArticleCatTreeTable.refreshPoint(id);  
		            },  
		            beforeExpand : function($tArticleCatTreeTable, id) {   
		            },  
		            afterExpand : function($tArticleCatTreeTable, id) {  
		            },  
		            beforeClose : function($tArticleCatTreeTable, id) {    
		            	
		            }  
		        });
		        
		        $tArticleCatTreeTable.initParents('${parentIds}', "0");//在保存编辑时定位展开当前节点
		       
		});
		
		function del(con,id){  
			jp.confirm('确认要删除文章分类吗？', function(){
				jp.loading();
	       	  	$.get("${ctx}/article/tArticleCat/delete?id="+id, function(data){
	       	  		if(data.success){
	       	  			$tArticleCatTreeTable.del(id);
	       	  			jp.success(data.msg);
	       	  		}else{
	       	  			jp.error(data.msg);
	       	  		}
	       	  	})
	       	   
       		});
	
		} 
		
		function refreshNode(data) {//刷新节点
            var current_id = data.body.tArticleCat.id;
			var target = $tArticleCatTreeTable.get(current_id);
			var old_parent_id = target.attr("pid") == undefined?'1':target.attr("pid");
			var current_parent_id = data.body.tArticleCat.parentId;
			var current_parent_ids = data.body.tArticleCat.parentIds;
			if(old_parent_id == current_parent_id){
				if(current_parent_id == '0'){
					$tArticleCatTreeTable.refreshPoint(-1);
				}else{
					$tArticleCatTreeTable.refreshPoint(current_parent_id);
				}
			}else{
				$tArticleCatTreeTable.del(current_id);//刷新删除旧节点
				$tArticleCatTreeTable.initParents(current_parent_ids, "0");
			}
        }
		function refresh(){//刷新
			var index = jp.loading("正在加载，请稍等...");
			$tArticleCatTreeTable.refresh();
			jp.close(index);
		}
</script>
<script type="text/html" id="tArticleCatTreeTableTpl">
			<td>
			<c:choose>
			      <c:when test="${fns:hasPermission('article:tArticleCat:edit')}">
				    <a  href="#" onclick="jp.openSaveDialog('编辑文章分类', '${ctx}/article/tArticleCat/form?id={{d.row.id}}','800px', '500px')">
							{{d.row.name === undefined ? "": d.row.name}}
					</a>
			      </c:when>
			      <c:when test="${fns:hasPermission('article:tArticleCat:view')}">
				    <a  href="#" onclick="jp.openViewDialog('查看文章分类', '${ctx}/article/tArticleCat/form?id={{d.row.id}}','800px', '500px')">
							{{d.row.name === undefined ? "": d.row.name}}
					</a>
			      </c:when>
			      <c:otherwise>
							{{d.row.name === undefined ? "": d.row.name}}
			      </c:otherwise>
			</c:choose>
			</td>
			<td>
							{{d.row.sort === undefined ? "": d.row.sort}}
			</td>
			<td>
				<div class="btn-group">
			 		<button type="button" class="btn  btn-primary btn-xs dropdown-toggle" data-toggle="dropdown">
						<i class="fa fa-cog"></i>
						<span class="fa fa-chevron-down"></span>
					</button>
				  <ul class="dropdown-menu" role="menu">
					<shiro:hasPermission name="article:tArticleCat:view">
						<li><a href="#" onclick="jp.openViewDialog('查看文章分类', '${ctx}/article/tArticleCat/form?id={{d.row.id}}','800px', '500px')"><i class="fa fa-search-plus"></i> 查看</a></li>
					</shiro:hasPermission>
					<shiro:hasPermission name="article:tArticleCat:edit">
						<li><a href="#" onclick="jp.openSaveDialog('修改文章分类', '${ctx}/article/tArticleCat/form?id={{d.row.id}}','800px', '500px')"><i class="fa fa-edit"></i> 修改</a></li>
		   			</shiro:hasPermission>
		   			<shiro:hasPermission name="article:tArticleCat:del">
		   				<li><a  onclick="return del(this, '{{d.row.id}}')"><i class="fa fa-trash"></i> 删除</a></li>
					</shiro:hasPermission>
		   			<shiro:hasPermission name="article:tArticleCat:add">
						<li><a href="#" onclick="jp.openSaveDialog('添加下级文章分类', '${ctx}/article/tArticleCat/form?parent.id={{d.row.id}}','800px', '500px')"><i class="fa fa-plus"></i> 添加下级文章分类</a></li>
					</shiro:hasPermission>
				  </ul>
				</div>
			</td>
	</script>