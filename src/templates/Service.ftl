package ${package_name}.service;
import java.util.List;
import java.util.Map;
import ${package_name}.entity.${table_name}Entity;
import ${package_name}.dao.${moduleId}DAO;
import com.gtmc.sp.common.exception.BusinessException;
import com.gtmc.sp.common.utils.PageBean;
import com.gtmc.sp.common.utils.PropertiesUtil;
import com.github.pagehelper.PageHelper;
import com.gtmc.sp.common.base.JobIds;
import com.gtmc.sp.common.base.MessageInfo;
import com.gtmc.sp.common.base.MsgIds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.gtmc.sp.modules.sys.utils.UserUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * ${moduleId}-${moduleName}  业务逻辑层
 *
 * 使用的表为：${table_name_small}
 * @ClassName: ${moduleId}Service 
 * @Description: TODO(${table_annotation})
 * @author ${author}
 * @date ${date}
*/
@Service
public class ${moduleId}Service{

	/** 写共通日志 */
	private static Logger logger = LoggerFactory.getLogger(${moduleId}Service.class);

	/** 调用DAO */
    @Autowired
    private ${moduleId}DAO ${moduleId?uncap_first}Dao;

   
   	/**
	 * @Title: findList 
     * @Description: TODO(分页查询) 
     * @param entity
     * @author ${author}  
     * @return PageBean<${table_name}Entity>    返回类型 
     * @throws	BusinessException
	 */
	public PageBean<${table_name}Entity> findList(${table_name}Entity entity) throws BusinessException{
		List<${table_name}Entity> ${table_name}List;
		try {
			PageHelper.startPage(entity.getPage(), entity.getRows());
			//检索数据
			${table_name}List = ${moduleId?uncap_first}Dao.findList(entity);
			logger.debug("机能：{}，检索成功！",JobIds.${moduleId});
			if(${table_name}List==null){
				throw new BusinessException(MsgIds.COMMENTSEA001);  
			}
		} catch (BusinessException e) {
			logger.error("机能：{}，业务异常，分页查询出现异常：",JobIds.${moduleId});
			logger.error(e.getMsgInfo().getMessageContent());
			throw e;
		} catch (Exception e) {
			//捕捉未定义的异常，SQL错误到处异常信息
			logger.error("机能：{}，非业务异常，分页查询出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			throw new BusinessException(MsgIds.CME03019);// 数据库异常
		}
		return new PageBean<${table_name}Entity>(${table_name}List);
	}
   
   
   
    /**
	 * @Title: insert 
	 * @Description: TODO(追加操作) 
	 * @param entity
	 * @author ${author}  
	 * @return int    返回类型 
	 */
	@Transactional(readOnly=false)
	public int insert(${table_name}Entity entity){
		int rows=0;
		${table_name}Entity primaryKey = null;
		try {
			primaryKey = new ${table_name}Entity();
	<#if pkMap?exists >
	    <#list pkMap?keys as key> 
			primaryKey.set${pkMap[key]?cap_first}(entity.get${pkMap[key]?cap_first}());
	    </#list>
    </#if>
			//唯一主键校验
			rows = ${moduleId?uncap_first}Dao.findTotalQty(primaryKey);
			if(rows>0){
				throw new BusinessException(MsgIds.COMMENTSEA003);
			}
			//追加数据 
			rows = ${moduleId?uncap_first}Dao.insert(entity);
			if(rows<1){
				throw new BusinessException(MsgIds.COMMENTADD001);
			}
			logger.debug("机能：{}，追加操作成功！",JobIds.${moduleId});
		} catch (BusinessException be) {
			logger.error("机能：{}，业务异常，追加操作出现异常：",JobIds.${moduleId});
			logger.error(be.getMsgInfo().getMessageContent());
			throw be;
		} catch (Exception e) {
			logger.error("机能：{}，非业务异常，追加操作出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			//捕捉未定义的异常，SQL错误到处异常信息
			throw new BusinessException(MsgIds.CME03019);// 数据库异常
		}finally{
			primaryKey = null;
		}
		return rows;
	}
	
	
	
    /**
	 * @Title: update 
	 * @Description: TODO(更新方法) 
	 * @param entity
	 * @author ${author} 
	 * @return int    返回类型 
	 * @throws	BusinessException
	 */
	@Transactional(readOnly=false)
	public int update(${table_name}Entity entity) throws BusinessException{
		int	rows=0;
		try {
			rows= ${moduleId?uncap_first}Dao.update(entity);
			if(rows < 1) 
				throw new BusinessException(MsgIds.COMMENTUP001);  
				
			logger.debug("机能：{}，更新操作成功！",JobIds.${moduleId});
		} catch (BusinessException e) {
			logger.error("机能：{}，业务异常，更新操作出现异常：",JobIds.${moduleId});
			logger.error(e.getMsgInfo().getMessageContent());
			throw e;
		} catch (Exception e) {
			logger.error("机能：{}，非业务异常，更新操作出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			//捕捉未定义的异常，SQL错误到处异常信息
			throw new BusinessException(MsgIds.CME03019);// 数据库异常
		}
		return rows;
	}
	
	
	
	/**
 	 * @Title: delete 
	 * @Description: TODO(删除操作) 
	 * @param ids
	 * @author ${author} 
	 * @return int    返回类型 
	 * @throws	BusinessException
	 */
	@Transactional(readOnly=false)
	@SuppressWarnings("deprecation")
	public int delete(String ids) throws BusinessException{
		int rows=0;
		String[] strs = ids.split(";");//切割ID集合
		${table_name}Entity entity = null;//实体类
	    String[] entitys = null;//切割实体集合
		try {
			for (String id : strs) {
				entity = new ${table_name}Entity();
	<#if pkMap?exists>
		<#if pkMap?keys?size != 1>
				entitys = id.split(",");//切割ID集合
		    <#list pkMap?keys as key> 
				entity.set${pkMap[key]?cap_first}(entitys[${key_index}]);
		    </#list>
	    <#else>
		    <#list pkMap?keys as key> 
				entity.set${pkMap[key]?cap_first}(id);
		    </#list>
	    </#if>
	</#if>
				//根据主键删除对应的数据
				rows=${moduleId?uncap_first}Dao.delete(entity);
				if(rows < 1) throw new BusinessException(MsgIds.COMMENTDEL001); 
			}
			
			logger.debug("机能：{}，删除操作成功！",JobIds.${moduleId});
		} catch (BusinessException e) {
			logger.error("机能：{}，业务异常，删除操作出现异常：",JobIds.${moduleId});
			logger.error(e.getMsgInfo().getMessageContent());
			throw e;
		} catch (Exception e) {
			logger.error("机能：{}，非业务异常，删除操作出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			//捕捉未定义的异常，SQL错误到处异常信息
			throw new BusinessException(MsgIds.CME03019);// 数据库异常
		}finally{
			strs=null;
			entitys = null;//切割实体集合
			entity = null;
		}
		return rows;
	}
   
   /**
    * 
    * @Title: findTotalQty 
    * @Description: TODO(获取数据个数) 
    * @param entity
    * @author ${author} 
    * @return int    返回类型 
    * @throws
    */
   public int findTotalQty(${table_name}Entity entity) {
    	try{
    		return ${moduleId?uncap_first}Dao.findTotalQty(entity);
    	} catch (Exception e) {
    		logger.error("机能：{}，非业务异常，获取数据个数出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			//捕捉未定义的异常，SQL错误到处异常信息
			throw new BusinessException(MsgIds.CME03019);// 数据库异常
		}
	}
	
	/**
	 * 
	 * @Title: seacher 
	 * @Description: TODO(获取分页数据) 
	 * @param @param entity
	 * @param @return    
	 * @author ${author} 
	 * @return PageBean<${table_name}Entity>    返回类型 
	 * @throws
	 */
	public PageBean<${table_name}Entity> seacher(${table_name}Entity entity){
    	PageHelper.startPage(entity.getPage(), entity.getRows());
		List<${table_name}Entity> slist = ${moduleId?uncap_first}Dao.seacher(entity);
		return new PageBean<${table_name}Entity>(slist);
    }
	
	
	/**
	 * 
	 * @Title: importExcel 
	 * @Description: TODO(导入数据) 
	 * @param jsonMap
	 * @author ${author} 
	 * @return MessageInfo    返回类型 
	 * @throws
	 */
	@Transactional(readOnly=false)
	@SuppressWarnings("unchecked")
	public MessageInfo importExcel(Map<String, Object> jsonMap) throws BusinessException {
		MessageInfo msgInfo = new MessageInfo();// 消息类
		// 获取list集合
		Object obj = null;
		List<${table_name}Entity> lists = null;
		boolean flag = false; // 字段校验是否通过标志
		StringBuffer error = null;
		try {
			logger.debug("导入导入的用户为：{}",UserUtils.getUser().getNo());
			
			obj = jsonMap.get("list");//获取list集合
			logger.debug("获取导入的数据，待转换数据：{}",obj);
			
			lists = (List<${table_name}Entity>) obj;//转换
			logger.debug("根据导入的数据进行转换，得到:{}条数据",lists==null?0:lists.size());
			
			flag = (boolean)jsonMap.get("success"); // 字段校验是否通过标志
			logger.debug("字段校验是否通过标志，结果为:{}",flag);
			
			// 删除原来临时表的数据
			${moduleId?uncap_first}Dao.deletes(UserUtils.getUser().getNo().trim());
			logger.debug("机能：{}，删除临时表操作成功！",JobIds.${moduleId});
			
			//循环封装用户
			for (${table_name}Entity entity : lists) {
				entity.setAddUser(UserUtils.getUser().getNo().trim());
				entity.setUpdUser(UserUtils.getUser().getNo().trim());
			}
			
			// 将数据插入到临时表
			${moduleId?uncap_first}Dao.insertsTemp(lists);
			logger.debug("机能：{}，数据插入到临时表操作成功！",JobIds.${moduleId});
			
			//查询重复的主键信息
			lists = ${moduleId?uncap_first}Dao.checkPrimaryKey(UserUtils.getUser().getNo().trim());
			logger.debug("机能：{}，重复的主键校验结果，存在{}条重复主键！",JobIds.${moduleId},lists==null?0:lists.size());
			
			// 做业务校验
			if(null!=lists&&!lists.isEmpty()){
				for (${table_name}Entity Entity : lists) {
					error = new StringBuffer();
					if(null!=Entity.getError()){
						error.append(Entity.getError());
					}
					error.append("唯一主键重复;");//需要手动补充
					Entity.setError(error.toString());
					Entity.setState("2");
					//保存错误信息
					${moduleId?uncap_first}Dao.updateTemp(Entity);
				}
				flag = false;
				logger.debug("机能：{}，导入操作中，主键是否重复校验不通过！！",JobIds.${moduleId});
			}
			
			// 执行更新操作
			if (flag) { 
				//更新或追加导入数据到正式表中
				${moduleId?uncap_first}Dao.saveOrUpdate(UserUtils.getUser().getNo().trim());
				msgInfo = PropertiesUtil.loadSuccessMsg(MsgIds.COMMENIMP002, JobIds.${moduleId});
				logger.debug("机能：{}，导入操作成功！",JobIds.${moduleId});
			} else {
				msgInfo = PropertiesUtil.loadMsg(MsgIds.COMMENIMP001, JobIds.${moduleId});
				logger.debug("机能：{}，导入操作失败！",JobIds.${moduleId});
			}	
			
		} catch (BusinessException be) {
			logger.error("机能：{}，业务异常，导入出现异常",JobIds.${moduleId});
			throw be;
		} catch (Exception e) {
			logger.error("机能：{}，非业务异常，导入出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			throw new BusinessException(MsgIds.COMMENIMP001);
		}finally{
			error = null;
			obj = null;
			lists = null;
		}
		return msgInfo;
	}
	/**
	 * 
	 * @Title: findimportData 
	 * @Description: TODO(获取临时表里面的数据) 
	 * @param @param userId
	 * @param @return    
	 * @author ${author} 
	 * @return List<${table_name}Entity>    返回类型 
	 * @throws
	 */
	public List<${table_name}Entity> findimportData(String userId) {
		return ${moduleId?uncap_first}Dao.findimportData(userId);
	}
	
	/**
	 * 
	 * @Title: findTempLists 
	 * @Description: TODO(获取分页的数据) 
	 * @param entity
	 * @author ${author} 
	 * @return List<${table_name}Entity>    返回类型 
	 * @throws
	 */
	public List<${table_name}Entity> findTempLists(${table_name}Entity entity) throws BusinessException {
		/*		// 开始分页，获取页码和每页显示数量
				PageHelper.startPage(entity.getPage(), entity.getRows());*/
		List<${table_name}Entity> spmPackitemTempList = null;
		try {	
			entity.setAddUser(UserUtils.getUser().getNo().trim());
			// 分页查询信息
			spmPackitemTempList = ${moduleId?uncap_first}Dao.findTempLists(entity);
		} catch (BusinessException be){
			throw be;
		} catch (Exception e) {
			logger.error("机能：{}，非业务异常，获取分页的数据出现异常：",JobIds.${moduleId});
			logger.error(e.getMessage());
			throw new BusinessException(MsgIds.CME03019);
		}
		return spmPackitemTempList;
		/*return new PageBean<${table_name}Entity>(spmPackitemTempList);*/
	}
}