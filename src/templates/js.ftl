/***	${moduleId}:${moduleName} ***/

/**
 *  验证框
 */
$.extend(
	$.fn.validatebox.defaults.rules,
	{//备注长度
		checkRemark :{
			validator : function(param) {
				//长度判断
				if(null!=param&&param.trim().length<=200){
					return true;
				}
				return false;
			},
			message : '备注最大长度为200'
		},
	<#list model_column as field>
		check${field.changeColumnName?cap_first} :{ //校验 ${field.columnComment}
			validator : function(param) {
				//格式校验（英数字校验和长度校验）
				if(checkAlphaNum(param)&&checkLength(param,1, 20)){//按需进行调整
					return true;
				}
				return false;
			},
			message : '输入的格式有误，请输入最大20位的英数字！'
		},
	</#list>
		checkTime :{
			validator : function(param) {
				//日期格式校验
				if(checkDate(param)){
					return true;
				}
				return false;
			},
			message : '日期格式有误，请输入YYYY/MM/dd'
		}
});

$(function() {
	$('#showMsg').linkbutton({
		disabled : true
	});	
	$('#dd').dialog('close');
});

//条件查询
function doSearch() {
	$('#tt').datagrid('options').url = rootPath+"a/${subMenu}/${moduleId}/findPage";
//		$("#test1").combobox("getValue");//获取下拉框的值
//		$("#test1").textbox("getValue");//获取文本框的值
//		$("input[name='test1']:checked").val();//获取文本框的值
//		$("input[name='test1']:checked").val();//获取文本框的值
	$('#tt').datagrid('load', {
	<#list model_column as field>
		//'${field.changeColumnName}':$("#${field.changeColumnName}1").combobox("getValue"),
	</#list>
	});
	$('#tt').datagrid('options').onLoadSuccess=function(data){
		if (data.total == 0) {
			$.messager.alert("系统信息","CME01019:没有符合查询条件的数据!");
			$('#tt').datagrid('options').onLoadSuccess=function(){};
			return ;
		}
		$('#tt').datagrid('options').onLoadSuccess=function(){};
	}
}    

var urls;
//弹出增加对话框
function newData() {
	var row = $('#tt').datagrid('getSelected');
	$('#dlg').dialog('open').dialog('setTitle', '添加页面');
<#if pkMap?exists>
	//设置主键可用
    <#list pkMap?keys as key> 
	$("#${pkMap[key]}2").textbox({readonly:false});
    </#list>
</#if>
	urls = rootPath+'a/${subMenu}/${moduleId}/insert';//
	$('#fm').form('load', row);
	$('#dlg').dialog({
		title:'添加页面',
		iconCls:'icon-windowAdd',
	}).dialog('open');
	
}

//弹出编辑对话框
function editData() {
	$('#fm').form('clear');
<#if pkMap?exists>
	//设置主键不可改
    <#list pkMap?keys as key> 
	$("#${pkMap[key]}2").textbox({readonly:true});
    </#list>
</#if>
	var rows = $('#tt').datagrid('getSelections');
	if(rows.length != 1 ){
		 $.messager.alert("提示信息","请选择一条要编辑的数据！","info");
		 return;
	}
	var row=rows[0];
	if (row) {
		$('#dlg').dialog('open').dialog('setTitle', '编辑页面');
		$('#fm').form('load', row);
		urls = rootPath+'a/${subMenu}/${moduleId}/update';//
	}

}



//增加和修改的保存方法
function saveData() {
	
	$('#fm').form('submit', {
		url : urls,
		onSubmit : function() {				
			return $(this).form('validate');
		},
		success : function(data) {
			var result = JSON.parse(data);
			var condition=this;
			if (result.success) {
				$.messager.alert('提示信息', result.messageContent,'info',function(){
					datagridReload(condition);
					$('#dlg').dialog('close');					
				});
				$('#tt').datagrid('reload'); 
			} else {
				$.messager.alert('提示信息', result.messageContent,'warning');
			}
		}
	});
}

//删除方法
function destroyData() {
	var ids = '';
	var rows = $('#tt').datagrid('getSelections');
	if (rows == null||rows=="") {
		$.messager.alert('提示信息', '请选择要删除行',"info");
		return;
	}
	for (var i = 0; i < rows.length; i++) {
<#if pkMap?exists>
	//设置主键不可改
    <#list pkMap?keys as key> 
		ids +=rows[i].${pkMap[key]}<#if key_has_next>+','</#if>;
    </#list>
    	ids +=';';
</#if>
	}
	
	if(rows){
		$.messager.confirm('提示信息', '你确定要删除'+rows.length+'条数据吗?', function(r) {
			if (r) {
				var url = rootPath+'a/${subMenu}/${moduleId}/delete';
				$.post(url, {//
					"ids" : ids
				}, function(result) {
					if (result.success) {
						$.messager.alert('提示信息', result.messageContent+rows.length+'条数据','info',function(){
							$('#tt').datagrid('reload');
						});
						$('#dlg').dialog('close'); // close the dialog
					} else {
						$.messager.alert('提示信息', result.messageContent,'warning');
					}
				}, 'json');
			}
		});
	}
}


//导出功能
function exportExcle()
{
	/* $.messager.progress({
		title:'请等到导出完成',
		msg:'正在进行导出工作，请勿进行其他操作...'
		}); */
	onloading();//开启加载效果
	urls = rootPath+"a/${subMenu}/${moduleId}/exportExcel";
	$.ajax({
        url:urls,
        type:'post',    
        //data:,
        dataType:'xml',
        success:function(data,textStatus){
           populateList(data,textStatus);
        },

        error:function(){
            $.messager.alert("提示信息",'系统出错','warning');
        }
     });

}
//导出的回调函数
function populateList(doc, textStatus) {
	/* $.messager.progress('close'); */
	removeload();//关闭加载效果
	if (textStatus == 'success') { // 信息已经成功返回，开始处理信息
		var root = doc.documentElement;
		var resultCode = root.childNodes[0].firstChild.data;
		var message = root.childNodes[1].firstChild.data;
		if(resultCode == 1){
			var url = root.childNodes[2].firstChild.data;
			window.location.href = rootPath+url;
		} else{
			$.messager.alert('提示信息',message,'warning');
		}
	} else { //页面不正常

		//alert("您所请求的页面有异常。");
	}
	
}



function importDate() {
	//得到上传文件的全路径  
	var fileName= $('#uploadFile').filebox('getValue');   
	if(fileName==""){
		$.messager.alert('提示', '请选择上传文件！', 'info');
	}else if(!isFileVelidate(fileName,['xlsx','xls'])){
		$.messager.alert('提示', '请选择"xls"或"xlsx"文件!', 'info');	
	}else{
	onloading();//开启加载效果
	var url = rootPath+'a/${subMenu}/${moduleId}/importExcel'
	$('#importForm').form('submit', {  
		url : url ,
		type : 'post',
		dataType: 'json', 
		data:$('#importForm').serialize(),  
		success : function(data) {
			var result = eval('(' + data + ')');
			if(result.success){
				$("#uploadFile").filebox('clear');
				$.messager.alert('提示信息', result.messageContent, 'info');
				
				$('#dd').dialog('close');
				$('#importForm').form('clear');
				//$('#tt').datagrid('loadData',result.obj);
				$('#tt').datagrid('reload'); 
				removeload();// 关闭加载效果
			}else{
				$('#importForm').form('clear');	
				$.messager.alert('提示信息', result.messageContent, 'error');
				removeload();// 关闭加载效果
				$('#showMsg').linkbutton({
					disabled : false
				});	
				
			}
		},
		error : function(data) {
			$.messager.alert('提示信息','系统出错','warning');
			$('#importForm').form('clear');
		}
	}); 
	}
}

//重置
function reset(){		
	onloading();//开启加载效果
	$('#ff').form('reset');   //表单检索条件清除
	$(".kpSearchForm [textboxname]").textbox("enable");  //表单检索条件清除
	
	$('#tt').datagrid('loadData',{total:0,rows:[]}); //清除列表
	setTimeout(function(){
		removeload();// 关闭加载效果
	},100);//客户自己说要加的
	
}



var showLog=showLogCommon({
	url:rootPath+'a/${subMenu}/${moduleId}/packConsistTempPage',
});