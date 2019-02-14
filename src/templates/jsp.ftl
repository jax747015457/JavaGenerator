<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/easyui/themes/insdep/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/css/resetKP.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyui/jquery.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" 
    src="<%=request.getContextPath()%>/static/easyui/easyui-lang-zh_CN.js"></script>
<!-- 可编辑网格需要 -->    
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyuidemo/support/jquery.edatagrid.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyuidemo/js/datagridOptions.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyuidemo/js/datagridReset.js"></script>
<style id="updateCell" style="text/css"></style>
<!-- 非网格部分js -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyuidemo/js/other.js"></script>	
<!-- 共通的校验js文件 -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/Validator.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<!-- css重置 -->	
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/easyuidemo/css/reset-2.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/css/resetKP.css">
<script type="text/javascript">
//根路径
var rootPath = '<%=request.getScheme()+"://"+request.getServerName()+":"+
    request.getServerPort()+request.getContextPath()+"/"%>';
</script>
<!-- 非网格部分js -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/static/easyuidemo/js/other.js"></script>	
<!-- css重置 -->	
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/easyuidemo/css/reset-2.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/static/easyui/font-awesome/css/font-awesome.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><msg:message key="${moduleId}_TITLE" /></title>
</head>
<!-- ${moduleName} -->
<body>
 <div class="loading"></div> 
	
	<%--**********************					*****************
	 **********************    画面一览 区域      *****************  
	 **********************                 *****************--%>
	<table id="tt" class="easyui-datagrid"
		style="width: 100%; height: 100%; background-color: transparent;" remoteSort="false"
		url="" toolbar="#tb" iconCls="icon-save" pageList="[10,50,100,500]" pageSize="500"
		rownumbers="true" pagination="true" data-options="total:114">
		<thead frozen="true">
			<tr>
				<th width="100" field="ck" checkbox="true" style="display: block;"></th>
			</tr>
		</thead>
		<thead>
			<tr>
				<#list model_column as field>
				<th width="130" data-options="field:'${field.changeColumnName}',align:'center'"
					sortable="true">${field.columnComment}</th>
				</#list>
			</tr>
		</thead>
	</table>
	<%--***********************************************************************************--%>
	
	
	<%--**********************					*****************
	 **********************    检索条件 区域      *****************  
	 **********************                 *****************--%>
	<div class="kpdatagrid" id="tb">
		<div class="kpSearchForm">
			<!-- <p class="kptitle">
				<msg:message key="${moduleId}_TITLE" />
			</p>-->
			<!-- 检索区-->
			<form id="ff" action="" method="post">
			<table>
				<tbody>
					<tr class="search_div">
						<span class=""></span>
						<td><span class="space">下拉框:</span></td>
						<td><input id="plantCode" class="easyui-combobox" name="plants" editable="true"
							data-options="panelHeight:'auto',data:'plant',valueField:'key1',textField:'joinString',url:'${"$"}{ctx}/${subMenu}/${moduleId}/findpackingSpot',loader:comboAllSelected"
							style="width: 120px" /></td>
						
						<td><span class="space">文本框:</span></td>
						<td><input id="pACKINGPARTSNO" class="easyui-textbox" maxlength="20"
							style="width: 160px"  data-options="validType:['checkPackingPartsNo']"><!-- onblur="seacher1();" -->
						<td><span class="space">复选框:</span></td>
						<td><label><input type="checkbox" name="setDefault"/>待修改</label></td>
						<td><span class="space">性别:</span></td>
						<td><label><input name="key2" type="radio" checked="checked" style="width:50px" value="1"/>男</label></td>
						<td><label><input name="key2" type="radio" style="width:50px" value="2"/>女</label></td>
						
						<td>
							<a href="#" class="easyui-linkbutton space btn-search"
								iconCls="icon-search" onclick="doSearch()">
								<msg:message key="COMMENT_SEACHER" /></a>
						</td>
						<td>
							<span class="space"><a href="#" id="" name="" class="easyui-linkbutton searchBut btn-reset"
							 iconCls="icon-reset" onclick=" reset()"><msg:message key="COMMENT_RESET" /></a></span>
						</td>
						
					</tr>
					<tr class="search_div">
						<td><span class="">T/C(FROM): </span></td>
						<td><input id="timeFrom" class="easyui-datebox" data-options="validType:['checkTime']"
							style="width: 120px" editable="true"></span></td>
						<span class=""></span>
						<td><span class="space">T/C(TO):</span>
						<td><input id="timeTo" class="easyui-datebox" data-options="validType:['checkTime']"
							style="width: 160px" editable="true"></td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
		<%--*************************************************************************************************************--%>
		
		
		
		
		<%--**********************					*****************
	 **********************    增删改导入导出按钮 区域      *****************  
	 **********************                 *****************--%>
		<div class="kpbuttons">
			<a href="#" class="easyui-linkbutton space btn-add" iconCls="icon-add"
				onclick="newData()"><msg:message key="COMMENT_ADD" /></a> 
			<a href="#" class="easyui-linkbutton btn-edit" iconCls="icon-edit"
				onclick="editData()"><msg:message key="COMMENT_UPDATE" /></a>
			<a href="#" class="easyui-linkbutton btn-remove" iconCls="icon-remove"
				onclick="destroyData()"><msg:message key="COMMENT_DELETE" /></a>
			<a href="#" class="easyui-linkbutton btn-undo" iconCls="icon-undo"
				onclick="exportExcle()"><msg:message key="COMMENT_EXPORT"/></a> 
			<a href="#" class="easyui-linkbutton btn-redo"
				iconCls="icon-redo" onclick="(function(){
					$('#dd').dialog('open');
					$('#importForm').form('clear');
				})()"><msg:message
					key="COMMENT_IMPORT" /></a>
		</div>
	</div>
	<%--*************************************************************************************************************--%>
	
	
	
	
	
	
	<%--**********************					*****************
	 **********************    编辑新增画面 区域      *****************  
	 **********************                 *****************--%>
	<div id="dlg" class="easyui-dialog kpwindow-change" closed="true" modal="true" iconCls="icon-windowAdd"
		buttons="#dlg-buttons">
		<form id="fm" method="post" novalidate>
		<!-- <label style="margin-left: 3%;line-height:35px;font-size:14pt;font-weight: bold;">基础数据:</label> -->
		<!--下拉框示例： <input name="type" id="type2" class="easyui-combobox" required="true" label="类型:" style="width: 100%" editable="true"
						data-options="panelHeight:'auto',data:'plant',valueField:'key1',textField:'key1',url:'${"$"}{ctx}/basicinfo/pb/findpackingSpot'" /> -->
			<table>
		<#list 0..11 as i>
			<#if model_column[i]??>
				<#if (i%2)==0>
				<tr>
					<td><label>${model_column[i].columnComment}:</label></td>
					<td><input name="${model_column[i].changeColumnName}" id="${model_column[i].changeColumnName}2" required="true"  class="easyui-textbox" 
						maxlength="20" data-options="validType:['check${model_column[i].changeColumnName?cap_first}']"
						label="${model_column[i].columnComment}:" style="width: 100%"></td>
				<#else>		
					<td><label>${model_column[i].columnComment}:</label></td>
					<td><input name="${model_column[i].changeColumnName}" id="${model_column[i].changeColumnName}2" required="true"  class="easyui-textbox" 
						maxlength="20" data-options="validType:['check${model_column[i].changeColumnName?cap_first}']"
						label="${model_column[i].columnComment}:" style="width: 100%"></td>
				</tr>
				</#if>	
			<#else>
				<#if (i%2)!=0>
					</tr>
				</#if>
				<#break>
			</#if>	
		</#list>
			</table>
		</form>
	</div>
	<%--*************************************************************************************************************--%>
	
	
	
	
	<%--**********************					*****************
	 **********************    新增或编辑页面按钮 区域      *****************  
	 **********************                 *****************--%>
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton c6 btn-ok"
			iconCls="icon-ok" onclick="saveData();" style="width: 90px"><msg:message key="COMMENT_SAVE"/></a> <a
			href="javascript:void(0)" class="easyui-linkbutton btn-cancel"
			iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
			style="width: 90px"><msg:message key="COMMENT_CANCEL"/></a>
	</div>
	<%--*************************************************************************************************************--%>
	
	
	<%--**********************					*****************
	 **********************    导入画面 区域      *****************  
	 **********************                 *****************--%>
	<div id="dd" class="easyui-dialog" style="padding:5px;width:550px;"
			title="导入文件" iconCls="icon-upload"
			toolbar="#dlg-toolbars" buttons="#dlg-buttonss"
			closed="true"
			modal="true">
		<p style="font-size:10px;height:50px;line-height:16px;color:#333333">*请使用模板导入数据,否则可能出现错误。请勿重复点击下载模板！</p>
	</div>
	<%--*************************************************************************************************************--%>
	
		<%--**********************					*****************
	 **********************    导入按钮 区域      *****************  
	 **********************                 *****************--%>
	<div id="dlg-toolbars" style="background:#ffffff;border-bottom:none">
		<form id="importForm"   action="${"$"}{ctx}/${subMenu}/${table_name}/importExcel"  method="post" enctype="multipart/form-data" style="padding:12px 0 8px 0;">
			<input class="easyui-filebox btn-label-blue" id="uploadFile" name="file" buttonText="选择文件" style="width:240px;height:26px">
			<a href="javascript:" id="btnImportSubmit" class="easyui-linkbutton btn-upload" iconCls="icon-upload"  onclick="importDate()">数据上传及更新</a>
			<a href="${"$"}{ctx}/${subMenu}/${moduleId}/import"  class="easyui-linkbutton btn-undo" iconCls="icon-undo" style="margin-left:16px">下载模板</a>
			<a href="javascript:" class="easyui-linkbutton btn-text-log" id="showMsg" iconCls="icon-text-log"  onclick="showLog()">日志信息</a>
		</form>
	</div>	
	<%--*************************************************************************************************************--%>
	
	
	
	<%--**********************					*****************
	 **********************    错误日志画面 区域      *****************  
	 **********************                 *****************--%>
	<div id="logDlg" class="easyui-dialog" closed="true" style="width: 800px;height:480px"
		buttons="#logDlg-buttons" modal="true">
		<input class="easyui-textbox kptextarea" data-options="multiline:true" id="logbox"
		    editable="false" style="width:100%;height:100%">
	</div>
	<div id="dlg-buttonss">
		<a href="#" class="easyui-linkbutton btn-cancel" iconCls="icon-cancel" onclick="javascript:$('#dd').dialog('close')">关闭</a>
	</div>
	<%--*************************************************************************************************************--%>
	
	
	
</body>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/${subMenu}/${moduleId}.js"></script>
</html>