<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>权限列表 </title>
<#include "../../common/include.ftl">
<script type="text/javascript">
$(function(){
	new Grid({});
});

function add(){
	$.openWin({url:'${ctxPath}/admin/auth/add/${menuId}',title:'新增权限'});
}

function edit(id){
	$.openWin({url:'${ctxPath}/admin/auth/edit?authId='+id,title:'编辑权限'});
}

function del(){
	var idArr = grid.getSelectIds();
	if(idArr.length < 1){
		$.alert('请选择需要删除的记录');
		return ;
	}
		$.confirm({
		 info:'您确定要删除记录吗？',
		 ok: function () {
				var datas = $("input[name='ids']:checked").serialize();
				showAjaxHtml({"wait": true});
				$.ajax({
					url:'${ctxPath}/admin/auth/delete',
					type: 'post',
					data: datas,
					dataType: 'json',
					cache: false,
					error: function(obj){
						showAjaxHtml({"wait": false,"type":"error", "msg": '删除权限配置出错!'});
				    },
				    success: function(obj){
				    	showAjaxHtml({"wait": false, "msg": obj.msg, "rs": obj.rs});
				    	if(obj.rs){
				    		$.info(obj.msg, function(){
				    			grid.reload();
				    			$.closeWin();
				    		});
				    	}
				    }
			});
		}
	});			
}

function change(id){
	showAjaxHtml({"wait": true});
	$.ajax({
		url:'${ctxPath}/admin/auth/changestatus',
		type: 'post',
		data: 'authId='+id,
		dataType: 'json',
		cache: false,
		error: function(obj){
			showAjaxHtml({"wait": false,"type":"error", "msg": '权限配置操作出错!'});
	    },
	    success: function(obj){
	    	showAjaxHtml({"wait": false, "msg": obj.msg, "rs": obj.rs});
	    	if(obj.rs){
	    		$.info(obj.msg, function(){
	    			grid.reload();
	    			$.closeWin();
	    		});
	    	}
	    }
	 });
}
</script>
</head>
<body>
	<div class="body-box-list" id="bodyBoxDiv">
		<div class="query-form">
		<form action="${ctxPath}/admin/auth/go/${menuId}" method="post" id="page_form" >
				<input type="hidden" id="pageNo" name="pageNo" value="${pageInfo.currentPage}" />
				<input type="hidden" id="pageSize" name="pageSize" value="${pageInfo.pageSize}" />
				<input type="hidden" id="totalPages" name="totalPages" value="${pageInfo.totalPage}" />
				
				<table cellpadding="0" cellspacing="0" width="100%">
						<col  width="10%"/>
						<col  width="40%"/>
						<col  width="10%"/>
						<col  width="40%"/>
					<tbody>
						<tr>
							<td class="td-label">权限名称</td>
							<td class="td-value"><input type="text" id="authName" name="authName" onkeyup="this.value=this.value.replace(/[, ]/g,'')" value="${authority.authName!''}" style="width:160px;"/></td>
							<td class="td-label">权限编码</td>
							<td class="td-value"><input type="text" id="authCode" name="authCode" onkeyup="this.value=this.value.replace(/[, ]/g,'')" value="${authority.authCode!''}" style="width:160px;" /></td>
						</tr>

						<tr>
							<td colspan="6" class="td-btn">
								<div class="sch_qk_con"> 
									<input onclick="grid.goPage(1);"  class="i-btn-s" type="button"  value="检索"/>
									<input onclick="grid.clearForm();"  class="i-btn-s" type="button"  value="清空"/>
								</div>
						  	</td>
						</tr>
					</tbody>
				</table>
		</form>
		</div>
		<div class="pageContent">
			<div class="panelBar" id="panelBarDiv">
            	<ul>
            		<@yirong.authorize authCode="AUTH_ADD">
                	<li>
                    	<a href="#" class="a1" onclick="add()">
					       <span>添加</span>
						</a>	
                    </li>
                    </@yirong.authorize>
                    <@yirong.authorize authCode="AUTH_DELETE">
                	<li>
						<a href="#" class="a2" onclick="del()">
							<span>删除</span>
						</a>
					</li>
					</@yirong.authorize>
                    <li class="line"></li>
                </ul>
				<div class="clear_float"> </div>
			</div>

			<div class="content-list">
				<table cellpadding="0" cellspacing="0" id="gridTable">
					<col width="5%"/>
					<col width="3%"/>
					<col width="10%"/>
					<col />
					<col />
					<col width="6%"/>
					<col />
					<thead>
						<tr>
							<th>
								序号
							</th>
							<th>
								<input type="checkbox" id="ck_all" onclick="grid.checkAll()" /> 
							</th>
							<th>
								操作
							</th>
							<th>
								权限名称
							</th>
							<th>
								权限编码
							</th>
							<th>
								状态
							</th>
							<th>
								备注
							</th>
						</tr>
					</thead>
					<tbody>
					<#if authList??>
						<#list authList as auth>
						<tr >
							<td class="td-seq">
								${auth_index+1}
							</td>
							<td class="td-center">
								<input type="checkbox" name="ids" value="${auth.authId!''}"/>
							</td>
							<td class="td-center">
								<a href="#" class="a3" onclick="javascript:edit(${auth.authId});">
									编辑 
								</a>
								<a href="#" class="a3" onclick="javascript:change(${auth.authId});">
									<#if auth.isEnable==1>
										禁用
									</#if>
									<#if auth.isEnable==0>
										启用
									</#if>
								</a>
							</td>
							<td class="td-center">
								${auth.authName!''}
							</td>
							<td class="td-center">
								${auth.authCode!''}
							</td>
							<td class="td-center">
								<#if auth.isEnable==1>
									启用
								</#if>
								<#if auth.isEnable==0>
									禁用
								</#if>
							</td>
							<td class="td-center">
							<#if auth.note??>
								<#if auth.note?length<=20  >
									${auth.note!''}
								<#else>
									${auth.note?substring(0,20)}
								</#if>
							</#if>
							</td>
						</tr>
						</#list>
					</#if>
					</tbody>
				</table>
			</div>
			<#include "../../common/pagination.ftl">
		</div> 
	</div>
</body>
</html>