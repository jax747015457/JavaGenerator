package ${package_name}.web;
import ${package_name}.entity.${table_name}Entity;
import ${package_name}.service.${moduleId}Service;
import ${package_name}.dao.${moduleId}DAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.io.IOException;
import com.gtmc.sp.common.base.Constant;
import com.gtmc.sp.common.base.JobIds;
import com.gtmc.sp.common.base.MessageInfo;
import com.gtmc.sp.common.base.MsgIds;
import com.gtmc.sp.common.config.ExcelProperties;
import com.gtmc.sp.common.exception.BusinessException;
import com.gtmc.sp.common.utils.CSVUtils;
import com.gtmc.sp.common.utils.DateUtils;
import com.gtmc.sp.common.utils.FileUtils;
import com.gtmc.sp.common.utils.LogPrinter;
import com.gtmc.sp.common.utils.PageBean;
import com.gtmc.sp.common.utils.PropertiesUtil;
import com.gtmc.sp.common.utils.excel.ExportExcel;
import com.gtmc.sp.modules.sys.entity.SystemTypeEntity;
import com.gtmc.sp.common.web.BaseController;
import com.gtmc.sp.modules.sys.service.SystemType;
import com.gtmc.sp.modules.sys.utils.UserUtils;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.File;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;




/**
 * ${moduleId}-${moduleName}  控制层
 *
 * 使用的表为：${table_name_small}
 * @ClassName: ${moduleId}Controller 
 * @Description: ${table_annotation}
 * @author ${author}
 * @date ${date}
 */
@Controller
@RequestMapping(value = "${"$"}{adminPath}/${subMenu}/${moduleId}")
public class ${moduleId}Controller  extends BaseController{

	/** 写共通日志 */
	private static Logger logger = LoggerFactory.getLogger(${moduleId}Controller.class);
	
	/**	调用机能的Service */
    @Autowired
    private ${moduleId}Service ${moduleId?uncap_first}Service;
    
    /** 调用常量服务层*/
	@Autowired
	private SystemType st;
	
	/**
 	 * @Title: initPage 
	 * @Description: TODO(页面初始化) 
	 * @author ${author}
	 * @return String 返回类型 
    */
    @RequestMapping(method = RequestMethod.GET)
    public String initPage() {
        return "modules/${subMenu}/${moduleId}";
    }
    
    /**
 	 * @Title: findPackingSpot 
	 * @Description: TODO(获取) 
	 * @author ${author}
	 * @return String 返回类型 
    */
    @RequestMapping("findPackingSpot")
	@ResponseBody
	public List<SystemTypeEntity> findPackingSpot() {
		List<String> list = new ArrayList<String>();
		list.add("key1");
		list.add("data1");
		return st.getJoinSystemType(list, ":", "PACKSPOT");
	}
	
	/**
     * @Title: findPage 
     * @Description: TODO(分页查询数据) 
     * @param entity
     * @param request
     * @param response
     * @param model
     * @author ${author}
     * @return Map<String,Object>    返回类型 
    */
    @RequestMapping("findPage")
    @ResponseBody
    public Map<String, Object> findPage(${table_name}Entity entity, HttpServletRequest request,HttpServletResponse response,Model model) {
    	MessageInfo msgInfo=new MessageInfo();//消息类
		PageBean<${table_name}Entity> pageBean = null;
		try {
			//得到分页对象
		    pageBean = ${moduleId?uncap_first}Service.findList(entity);
			msgInfo=PropertiesUtil.loadSuccessMsg(MsgIds.COMMENTSEA002, JobIds.${moduleId});	
		} catch (BusinessException ex) {
			msgInfo =ex.getMsgInfo(); //获取消息异常
			logger.error("机能：{}，分页查询出现异常：",JobIds.${moduleId});
			logger.error(msgInfo.getMessageContent());
			this.logUtilService.writeLog("${moduleId}-${moduleName}-查询", msgInfo);
	    }
        return getPageJson(pageBean);
    }
	
	/**
	 * @Title: insert 
     * @Description: TODO(追加方法) 
     * @param entity	
     * @author ${author}
     * @return String    返回类型 
	 */
	@RequestMapping("insert")
	@ResponseBody
	public String insert(${table_name}Entity entity){
		MessageInfo msgInfo=new MessageInfo();
		try {
			entity.setAddUser(UserUtils.getUser().getLoginName());
			//追加操作
			${moduleId?uncap_first}Service.insert(entity);
			logger.info("机能：{}，追加操作成功！",JobIds.${moduleId});
			msgInfo=PropertiesUtil.loadSuccessMsg(MsgIds.COMMENTADD002, JobIds.${moduleId});
		} catch (BusinessException ex) {
			msgInfo =ex.getMsgInfo(); //获取消息异常
			logger.error("机能：{}，追加操作出现异常：",JobIds.${moduleId});
			logger.error(msgInfo.getMessageContent());
			this.logUtilService.writeLog("${moduleId}-${moduleName}-追加", msgInfo);			
		}
		return JSONObject.fromObject(msgInfo).toString();
	}
	
	/**
	 * @Title: update 
	 * @Description: TODO(更新方法) 
	 * @param entity
	 * @author ${author}
	 * @return String    返回类型 
	 * */
	@RequestMapping("update")
	@ResponseBody
	public String update(${table_name}Entity entity){
		MessageInfo msgInfo=new MessageInfo();//消息类
		try {
			entity.setUpdUser(UserUtils.getUser().getLoginName());
			//更新操作
			${moduleId?uncap_first}Service.update(entity);
			logger.info("机能：{}，更新操作成功！",JobIds.${moduleId});
			msgInfo=PropertiesUtil.loadSuccessMsg(MsgIds.COMMENTUP002, JobIds.${moduleId});
		} catch (BusinessException ex) {
			msgInfo =ex.getMsgInfo(); //获取消息异常
			logger.error("机能：{}，更新操作出现异常：",JobIds.${moduleId});
			logger.error(msgInfo.getMessageContent());
			this.logUtilService.writeLog("${moduleId}-${moduleName}-更新", msgInfo);		
		}		
		return JSONObject.fromObject(msgInfo).toString();
	}
	
	/**
	 * @Title: delete 
	 * @Description: TODO(批量删除单一方法) 
	 * @param request
	 * @author ${author}
	 * @return String    返回类型 
	 * */
	@RequestMapping("delete")
	@ResponseBody
	public String delete(String ids){
		MessageInfo msgInfo=new MessageInfo();//消息类
		try {
			//删除操作
			${moduleId?uncap_first}Service.delete(ids);
			logger.info("机能：{}，删除操作成功！",JobIds.${moduleId});
			msgInfo=PropertiesUtil.loadSuccessMsg(MsgIds.COMMENTDEL002, JobIds.${moduleId});
		} catch (BusinessException ex) {	
			msgInfo =ex.getMsgInfo(); //获取消息异常
			logger.error("机能：{}，批量删除出现异常：",JobIds.${moduleId});
			logger.error(msgInfo.getMessageContent());
			this.logUtilService.writeLog("${moduleId}-${moduleName}-删除", msgInfo);		
		}		
		return JSONObject.fromObject(msgInfo).toString();
	}

	/**
	 * 
	 * @Title: export 
	 * @Description: TODO(导出模板) 
	 * @param entity
	 * @param request
	 * @param response
	 * @param model
	 * @author ${author}
	 * @return void    返回类型 
	 * @throws	IOException
	 */
	@RequestMapping("exportExcel")
	public void export(${table_name}Entity entity,HttpServletRequest request,HttpServletResponse response,Model model) throws IOException{
		//导出类型：excel、csv
		//转换时间格式
		String type = "excel";
		//文件名称
		String name = "${moduleName}";
		int maxPage= maxSize(entity);
		String resultCode = "1"; //1成功，2失败
		String message = "导出成功"; //信息
		String url = "url"; //种子文件
		if(maxPage == 0){
			//返回空提示
			resultCode = "2";
			message = "没有符合条件的数据";
		}else{
			//得到用户登录名
			String username = UserUtils.getUser().getName();
			//获得临时文件目录
			String folder=request.getSession().getServletContext().getRealPath("/")+"export/";
			
			//如果不存在则创建文件目录
			File folderFile = new File(folder);
			if (!folderFile.exists()) {
				folderFile.mkdir(); 
			}
			
			//获取时间
			String dateName = DateUtils.getDate("yyyyMMddHHmmss");
			List<?> list = null;
			String fileName ="";
			for(int i = 0;i<maxPage;i++){
				list = getPageList(i+1,entity);
				//判断是否存在excel，不存在则创建
				File file = new File(folder+type);
				if (!file.exists()) {
					file.mkdir(); //创建excel
				}
				File file2 = new File(folder+type+"/"+dateName);
				if (!file2.exists()) {
					file2.mkdir(); //创建新文件夹
				}
				logger.debug("机能：{}，即将生成的文件类型为：{}",JobIds.${moduleId},type);
				//根据type，将list转化成文件
				if (type.equals("excel")) {
					//===========Excel============
					 fileName = username+"-"+name+DateUtils.getDate("yyyyMMddHHmmss")+i+".xlsx"; 
					new ExportExcel(name, ${table_name}Entity.class)  
					.setDataList(list)  
					.writeFile(file.getPath()+"/"+dateName+"/"+fileName)
					.dispose();
				}else if(type.equals("csv")){
					//===========CSV==============
					//设置文件名
					 fileName = username+"-"+name+DateUtils.getDate("yyyyMMddHHmmss")+i+".csv";
					//获得所有注解
					List<Object[]> annotationList = getAnnotation(${table_name}Entity.class);
					//得到注解title
					List<String> datalist = getAnnotationTitle(annotationList);
					//得到String list
					List<String> csvList= CSVUtils.getDataList(list, annotationList,datalist);
					//导出
					CSVUtils.exportCsv(file.getPath()+"/"+dateName+"/"+fileName, csvList);
				}
			}
			if(maxPage > 1){
				//压缩
				FileUtils.zipFiles(folder +type+"/"+dateName+"/" ,"*",folder +type+"/"+dateName+".zip");
				
				logger.debug("机能：{}，成功压缩文件({})",JobIds.${moduleId},fileName);
				
				url = "export/" +type+"/"+dateName+".zip";
			}else{
				url = "export/" +type+"/"+dateName+"/"+fileName;
			}
			
		}
			PrintWriter out = null;
			response.setContentType("text/xml; charset=utf-8");
			StringBuffer str = new StringBuffer();
			str.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n");
			str.append("<result>");
			str.append("<resultCode>");
			str.append(resultCode);
			str.append("</resultCode>");
			str.append("<message>");
			str.append(message);
			str.append("</message>");
			str.append("<url>");
			str.append(url);
			str.append("</url>");
			str.append("</result>");
			try {
				out = response.getWriter();
				out.print(str.toString());
			} catch (IOException e) {
				logger.error("机能：{}，导出文件出现异常：",JobIds.${moduleId});
				logger.error(e.getMessage());
				LogPrinter.printStackTrace(e);
			}
		logger.debug("机能：{}，文件响应成功！",JobIds.${moduleId});
	}
	
	
	
	 /**
	 * 
	 * @Title: maxSize 
	 * @Description: TODO(获取导出数据的总页数：总条数/最大分页数（向上取整）) 
	 * @param entity
	 * @author ${author} 
	 * @return int    返回类型 
	 * @throws
	 */
	private int maxSize(${table_name}Entity entity) {
		double totalQty = ${moduleId?uncap_first}Service.findTotalQty(entity);
		return (int)Math.ceil(totalQty / ExcelProperties.MAXEXPORT);
	}
	
	
	/**
	 * @Title: getPageList 
	 * @Description: TODO(获取分页数据) 
	 * @param i	页码
	 * @param entity	检索条件
	 * @return List<?>    返回类型 
	 */
	private List<?> getPageList(int i, ${table_name}Entity entity) {
		entity.setPage(i);
		entity.setRows(ExcelProperties.MAXEXPORT);
		PageBean<${table_name}Entity> pageBean = ${moduleId?uncap_first}Service.seacher(entity);
		return pageBean.getList();
	}
	
	/**
	 * 
	 * @Title: importFileTemplate 
	 * @Description: TODO(导入模板下载) 
	 * @param request
	 * @param response
	 * @param model    
	 * @return void    返回类型 
	 * @throws
	 */	
	@RequestMapping(value = "import", method=RequestMethod.GET)
	public void importFileTemplate(HttpServletRequest request,HttpServletResponse response,Model model) {
		try {
			String fileName = "${moduleName}导入模板.xlsx";
			String folder = request.getSession().getServletContext().getRealPath("/")+"temp/"+fileName;
			FileUtils.downFile(new File(folder), request, response);
			logger.info("机能：{}，导入模版下载成功！",JobIds.${moduleId});
		} catch (Exception e) {
			logger.error("机能：{}，导入数据出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
		}
	}
	
	/**
	 * 
	 * @Title: importFile 
	 * @Description: TODO(数据导入方法) 
	 * @param @param file
	 * @param @param redirectAttributes
	 * @param @return
	 * @param @throws Exception    
	 * @return String    返回类型 
	 */
	@RequestMapping(value = "importExcel", method=RequestMethod.POST)
	@ResponseBody
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) throws Exception {
		MessageInfo msgInfo = new MessageInfo();//消息类	
		try {
			//参数3：代表从excl第3行读取数据，当输入小于1的数字时就不用校验标题了
			Map<String,Object> jsonMap = importDoc(file, ${table_name}Entity.class, ${moduleId}DAO.class,3);
			msgInfo = this.${moduleId?uncap_first}Service.importExcel(jsonMap);	
			//String userId=UserUtils.getUser().getLoginName();
			//List<${table_name}Entity> rows = ${moduleId?uncap_first}Service.findimportData(userId);
			//msgInfo.setObj(rows);
			msgInfo.setObj((List<${table_name}Entity>) jsonMap.get("list"));
		} catch (BusinessException ex) {
			msgInfo = ex.getMsgInfo(); // 获取消息异常
			this.logUtilService.writeLog("${moduleId}-${moduleName}-导入", msgInfo);
		} catch (Exception ex){
			msgInfo.setMessageContent(ex.getMessage());
			msgInfo.setSuccess(false); 
			this.logUtilService.writeLog("${moduleId}-${moduleName}-导入", msgInfo);
		}
		return JSONObject.fromObject(msgInfo).toString();
	}
	
	/**
	 * 
	 * @Title: findTempLists 
	 * @Description: TODO(获取分页数据) 
	 * @param entity
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception    
	 * @return String    返回类型 
	 */
	@RequestMapping("packConsistTempPage")
	@ResponseBody
	public List<${table_name}Entity> findTempLists(${table_name}Entity entity, HttpServletRequest request,
			HttpServletResponse response, Model model) throws BusinessException {
		MessageInfo msg = new MessageInfo();
		List<${table_name}Entity> pageBean = null;
		try {
			// 得到分页对象
			pageBean = ${moduleId?uncap_first}Service.findTempLists(entity);
		} catch (BusinessException ex) {
			msg = ex.getMsgInfo(); // 获取消息异常
			this.logUtilService.writeLog("${moduleId}-${moduleName}-获取临时表数据", msg);
		} catch (Exception ex) {
			msg.setMessageContent(ex.getMessage());
			msg.setSuccess(false);
			this.logUtilService.writeLog("${moduleId}-${moduleName}-获取临时表数据", msg);
		}
		return pageBean;
	}
	
	
	
	 <#list Dictionaries?split(";") as field>
	 	/**
		 * 
		 * @Title: find${field?capitalize}Dic 
		 * @Description: TODO(获取常量数据) 
		 * 	${field}:
		 *		
		 * @return List<SystemTypeEntity>    返回类型 
		 */
	 	@RequestMapping("find${field?capitalize}Dic")
		@ResponseBody
		public List<SystemTypeEntity> find${field?capitalize}Dic() {
			List<String> list = new ArrayList<String>();
			list.add("key1");
			list.add("data1");
			return st.getJoinSystemType(list, ":", "${field}");
		}
	 </#list>
	
}