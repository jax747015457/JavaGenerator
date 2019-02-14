package ${package_name}.entity;

import org.hibernate.validator.constraints.NotEmpty;
import com.gtmc.sp.common.persistence.PageEntity;
import com.gtmc.sp.common.utils.excel.annotation.ExcelField;
import java.util.Date;
import javax.validation.constraints.Pattern;
 
 
 
 /**
 * 实体类：${moduleName}
 *
 * 使用的表为：${table_name_small}
 * @Description: ${moduleId}-${moduleName}
 * @author ${author}
 * @date ${date}
*/
public class ${table_name}Entity extends PageEntity{

	<#-- 生成字段属性 -->
	<#list model_column as field>
	/**${field.columnComment}**/
	private String ${field.changeColumnName};
	</#list>	
	/** 开始时间/日期 **/
	private String timeFrom;
	/** 结束时间/日期 **/
	private String timeTo;
	/** 行号 **/
	private String line; //行号
	/** 状态 1成功，2失败 **/
	private String state; //状态 1成功，2失败
	/** 错误信息 **/
	private String error; //错误信息
	/** 导入人 **/
	private String cupdUser; //导入人
	/** 记录数 **/
	private int count;
	
	<#-- 生成字段get方法 -->
	<#list model_column as field>
	/**
	 * 
	 * @Title: get${field.changeColumnName?cap_first}
	 * @Description: TODO(获取 ${field.columnComment}) 
	 * @author ${author} 
	 * @return String   返回类型 
	 * @throws
	 */
	//@NotEmpty(message="${field.columnComment}不能为空")
	@Pattern(regexp = "^[1-9]\\d*$", message = "${field.columnComment}只能为数字")
	@ExcelField(title="${field.columnComment}", align=2, sort= ${field_index+1})
	public String get${field.changeColumnName?cap_first}(){
		return this.${field.changeColumnName};
	}
	</#list>
	/**
	 * 
	 * @Title: getTimeFrom
	 * @Description: TODO(获取 开始时间/日期) 
	 * @author ${author} 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getTimeFrom() {
		return timeFrom;
	}
	/**
	 * 
	 * @Title: getLine
	 * @Description: TODO(获取 行号) 
	 * @author ${author} 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getLine() {
		return line;
	}
	/**
	 * 
	 * @Title: getState
	 * @Description: TODO(获取 状态 1成功，2失败) 
	 * @author ${author} 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getState() {
		return state;
	}
	/**
	 * 
	 * @Title: getError
	 * @Description: TODO(获取 错误信息) 
	 * @author ${author} 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getError() {
		return error;
	}
	/**
	 * 
	 * @Title: getCupdUser
	 * @Description: TODO(获取 导入人) 
	 * @author ${author} 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getCupdUser() {
		return cupdUser;
	}
	
	<#-- 生成字段set方法 -->
	<#list model_column as field>
	/**
	 * 
	 * @Title: set${field.changeColumnName?cap_first} 
	 * @Description: TODO(设置 ${field.columnComment}) 
	 * @param @param ${field.changeColumnName}    
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */ 
	public void set${field.changeColumnName?cap_first}(String ${field.changeColumnName}){
		this.${field.changeColumnName} = ${field.changeColumnName};
	}
	</#list>
 	/**
	 * 
	 * @Title: getTimeTo
	 * @Description: TODO(设置 结束时间/日期) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public String getTimeTo() {
		return timeTo;
	}
	/**
	 * 
	 * @Title: setLine
	 * @Description: TODO(设置取 行号) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setLine(String line) {
		this.line = line;
	}
	/**
	 * 
	 * @Title: setState
	 * @Description: TODO(设置 状态 1成功，2失败) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setState(String state) {
		this.state = state;
	}
	/**
	 * 
	 * @Title: setError
	 * @Description: TODO(设置 错误信息) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setError(String error) {
		this.error = error;
	}
	/**
	 * 
	 * @Title: setCupdUser
	 * @Description: TODO(设置 导入人) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setCupdUser(String cupdUser) {
		this.cupdUser = cupdUser;
	}
	
	
	/**
	 * 
	 * @Title: setTimeFrom
	 * @Description: TODO(设置 导入人) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setTimeFrom(String timeFrom) {
		this.timeFrom = timeFrom;
	}
	
	
	
	
	/**
	 * 
	 * @Title: setTimeTo
	 * @Description: TODO(设置 导入人) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setTimeTo(String timeTo) {
		this.timeTo = timeTo;
	}
	
	/**
	 * 
	 * @Title: getCount
	 * @Description: TODO(设置 导入人) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public int getCount() {
		return count;
	}
	/**
	 * 
	 * @Title: setCount
	 * @Description: TODO(设置 导入人) 
	 * @author ${author} 
	 * @return void    返回类型 
	 * @throws
	 */
	public void setCount(int count) {
		this.count = count;
	}
	
}
	
	
 
