package ${package_name}.dao;

import com.gtmc.sp.common.persistence.CrudDao;
import com.gtmc.sp.common.persistence.annotation.MyBatisDao;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import ${package_name}.entity.${table_name}Entity;

/**
 * ${moduleId}-${moduleName} 数据访问层
 *
 * 使用的表为：${table_name_small}
 * @ClassName: ${moduleId}DAO 
 * @Description: ${table_annotation}
 * @author ${author}
 * @date ${date}
 *
*/
@MyBatisDao 
public interface ${moduleId}DAO extends CrudDao<${table_name}Entity> {

	/**
	 * 
	 * @Title: findTotalQty 
	 * @Description: TODO(查询数据条数) 
	 * @param entity
	 * @author ${author} 
	 * @return int    返回类型 
	 * @throws
	 */
	public int findTotalQty(${table_name}Entity entity);
	
	/**
	 * 
	 * @Title: seacher 
	 * @Description: TODO(查询业务数据) 
	 * @param entity
	 * @author ${author} 
	 * @return List<${table_name}Entity>    返回类型 
	 * @throws
	 */
	public List<${table_name}Entity> seacher(${table_name}Entity entity);
	/**
	 * 
	 * @Title: findimportData 
	 * @Description: TODO() 
	 * @param userId
	 * @author ${author} 
	 * @return List<spTParmSettingEntity>    返回类型 
	 * @throws
	 */
	public List<${table_name}Entity> findimportData(String userId);
	
	
	/**
	 * 
	 * @Title: deletes 
	 * @Description: TODO() 
	 * @param userName
	 * @author ${author} 
	 * @return Integer    返回类型 
	 * @throws
	 */
	public Integer deletes(@Param("userName")String userName);
 	
 	/**
	 * 
	 * @Title: insertsTemp 
	 * @Description: TODO() 
	 * @param list
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
 	public void insertsTemp(List<${table_name}Entity> list);
 	
 	/**
	 * 
	 * @Title: inserts 
	 * @Description: TODO() 
	 * @param userName
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
 	public void inserts(@Param("userName")String userName);
 	
 	/**
	 * 
	 * @Title: inserts 
	 * @Description: TODO() 
	 * @param entity
	 * @author ${author} 
	 * @return list    返回类型 
	 * @throws
	 */
 	public List<${table_name}Entity> findTempLists(${table_name}Entity entity);
 	
 	
 	/**
	 * 
	 * @Title: saveOrUpdate 
	 * @Description: TODO() 
	 * @param entity
	 * @author ${author} 
	 * @return int    返回类型 
	 * @throws
	 */
 	public int saveOrUpdate(@Param("userName")String userName); 
 	
 	/**
	 * 查询临时表中的重复主键
	 * @Title: checkPrimaryKey 
	 * @Description: TODO() 
	 * @param userName
	 * @author ${author} 
	 * @return List<${table_name}Entity>    返回类型 
	 * @throws
	 */
 	public List<${table_name}Entity> checkPrimaryKey(@Param("userName")String userName); 
 	
 	/**
	 * 更新临时表中异常信息
	 * @Title: updateTemp 
	 * @Description: TODO() 
	 * @param entity
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
 	public void updateTemp(${table_name}Entity entity); 
}