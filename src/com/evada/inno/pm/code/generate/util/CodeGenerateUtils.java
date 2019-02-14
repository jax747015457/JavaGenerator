package com.evada.inno.pm.code.generate.util;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.evada.inno.pm.code.generate.model.ColumnClass;

import freemarker.template.Template;
import oracle.jdbc.OracleConnection;

/**
 * 描述：代码生成器
 * Created by Ay on 2017/5/1.
 */
public class CodeGenerateUtils {

	/**
	 * 生成模板基础参数
	 */
	private final String URL = "jdbc:oracle:thin:@192.168.31.139:1521:orcl";//数据库链接
//	private final String URL = "jdbc:oracle:thin:@172.16.136.128:1521:local01";//数据库链接
	private final String USER = "OUSLC08OSPUSER";//登录账号
	private final String PASSWORD = "test";//登录密码
	private final String diskPath = "D:\\Generator\\";//根路径
		
	
	/**
	 * 生成模板关键参数
	 */
//	private final String tableName = "SP_M_BOX_BASICINFO";//表名
//	private final String moduleId = "GSPM019";//机能ID
//	private final String moduleName = "箱code基础数据维护";//机能名
//	private final String subDirName = "basicinfo";//模块名
//	private final String AUTHOR = "zhaoyf";//操作人
//	private final String tableAnnotation = "纳入荷资中用到的箱code信息维护画面";//描述
//	private final boolean isfalse = true;//是否生成导入模板，true生成，false不生成
	private final String tableName = "SP_S_SELECT_PARTSNO";//表名
	private final String moduleId = "GSPS005";//机能ID
	private final String moduleName = "稼动日历维护（稼动日历设定）";//模块名+机能名
	private final String subDirName = "basicinfo";//模块名
	private final String AUTHOR = "ChengYongWen";//操作人
	private final String tableAnnotation = "稼动日历设定";//描述
	
	
	
	
	
	
	
	/**
	 * 目前不可用,功能
	 */
//	private final boolean isfalse = false;//是否生成导入模板，true生成，false不生成；目前不可用
	//是否需要生成 获取字典方法,填写字典ID,如没有常量，直接写
	private final String Dictionaries = "";
	
	/**
	 * 生成模板辅助参数
	 */
	private final String packageName = "com.gtmc.sp.modules."+subDirName;
	private final String CURRENT_DATE = new Date().toString();
	private final String DRIVER = "oracle.jdbc.driver.OracleDriver";
	private String changeTableName = UnderlineToHump(tableName);
	private String javaRootPath = "";
	private String mapperRootPath = diskPath+"\\src\\main\\resources\\mappings\\modules\\"+subDirName+"\\";
	private String jspRootPath = diskPath+"\\src\\main\\webapp\\WEB-INF\\views\\modules\\"+subDirName+"\\";
	private String jsRootPath = diskPath+"\\src\\main\\webapp\\js\\"+subDirName+"\\";
	private String xlsxRootPath = diskPath+"\\src\\main\\webapp\\temp\\";
	private Map<String, String> pkMap = null; //主键
	public Connection getConnection() throws Exception{
		Class.forName(DRIVER);
		Connection connection= DriverManager.getConnection(URL, USER, PASSWORD);
		return connection;
	}

	public static void main(String[] args) throws Exception{
		CodeGenerateUtils codeGenerateUtils = new CodeGenerateUtils();
		codeGenerateUtils.generate();
	}

	public void generate() throws Exception{
		try {
			javaRootPath = diskPath +"\\src\\main\\java\\"+packageName.replaceAll("\\.", "/") +"/";
			createPackage(javaRootPath);
			Connection connection = getConnection();
			if (connection instanceof OracleConnection) {//设置Oracle数据库的表注释可读
				((OracleConnection) connection).setRemarksReporting(true);//设置连接属性,使得可获取到表的REMARK(备注)
			}
			DatabaseMetaData databaseMetaData = connection.getMetaData();
			ResultSet rsPrimaryKey =databaseMetaData.getPrimaryKeys(null, null, tableName);
			String primaryKey = getPrimaryKeys(rsPrimaryKey);
			String primaryKeyColumns = UnderlineToHump(primaryKey);
			pkMap = new HashMap<String, String>();
			String[] primaryKeys = primaryKey.split(",");
			String[] primaryKeyColumnss = primaryKeyColumns.split(",");
			for (int i = 0; i < primaryKeys.length; i++) {
				pkMap.put(primaryKeys[i], primaryKeyColumnss[i]);
			}
			ResultSet resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			//生成Model文件
			generateModelFile(resultSet);
			//生成xlsx文件
//			if(isfalse){
//				resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
//				//生成xlsx文件
//				generateXLSXFile(resultSet);
//			}
			//生成Mapper文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateMapperFile(resultSet);
			//生成Dao文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateDaoFile(resultSet);
			//生成服务层接口文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateServiceFile(resultSet);
			//生成Controller层文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateControllerFile(resultSet);
			//生成JSP文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateJSPFile(resultSet);
			//生成JS文件
			resultSet = databaseMetaData.getColumns(null,"%", tableName,"%");
			generateJSFile(resultSet);
			System.out.println("---------------全部生成完毕--------------");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}finally{
			
		}
	}
	/**
	 * 生成xlsx
	 * @Title: generateXLSXFile 
	 * @Description: TODO(这里用一句话描述这个方法的作用) 
	 * @param @param resultSet    
	 * @author zhaoyf 
	 * @return void    返回类型 
	 * @throws
	 */
	private void generateXLSXFile(ResultSet resultSet) throws Exception {
		createPackage(xlsxRootPath);
		final String suffix = "导入模板.xlsx";
		final String path = xlsxRootPath + moduleName + suffix;
		final String templateName = "xlsx.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		List<ColumnClass> columnClassList = new ArrayList<>();
		columnClassList = getColumn(resultSet);
		dataMap.put("model_column",columnClassList);
		generateFileByTemplate(templateName,mapperFile,dataMap);
	}

	/**
	 * 判断路径是否存在，不存在则创建
	 * @param dirpath
	 */
	private void createPackage(String dirpath){

		File descFile = new File(dirpath);
		if (!descFile.exists()) {
			// 如果目标文件所在的目录不存在，则创建目录
			// 创建目标文件所在的目录
			if (!descFile.mkdirs()) {
				System.out.println("创建目标文件所在的目录失败!");
			}
		}
	}

	private void generateModelFile(ResultSet resultSet) throws Exception{
		String packagePath = javaRootPath+"entity/";
		createPackage(packagePath);
		final String suffix = "Entity.java";
		final String path = packagePath + changeTableName + suffix;
		final String templateName = "Model.ftl";
		File mapperFile = new File(path);
		List<ColumnClass> columnClassList = new ArrayList<>();
		columnClassList = getColumn(resultSet);
		Map<String,Object> dataMap = new HashMap<>();
		dataMap.put("model_column",columnClassList);
		generateFileByTemplate(templateName,mapperFile,dataMap);

	}


	private void generateControllerFile(ResultSet resultSet) throws Exception{
		String packagePath = javaRootPath+"web/";
		createPackage(packagePath);
		final String suffix = "Controller.java";
		final String path = packagePath + moduleId + suffix;
		final String templateName = "Controller.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		generateFileByTemplate(templateName,mapperFile,dataMap);
	}


	private void generateServiceFile(ResultSet resultSet) throws Exception{
		String packagePath = javaRootPath+"service/";
		createPackage(packagePath);
		final String suffix = "Service.java";
		final String path = packagePath + moduleId + suffix;
		final String templateName = "Service.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		generateFileByTemplate(templateName,mapperFile,dataMap);
	}

	private void generateJSPFile(ResultSet resultSet) throws Exception{
		createPackage(jspRootPath);
		final String suffix = ".jsp";
		final String path = jspRootPath + moduleId + suffix;
		final String templateName = "jsp.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		List<ColumnClass> columnClassList = new ArrayList<>();
		columnClassList = getColumn(resultSet);
		dataMap.put("model_column",columnClassList);
		generateFileByTemplate(templateName,mapperFile,dataMap);
	}
	private void generateJSFile(ResultSet resultSet) throws Exception{
		createPackage(jsRootPath);
		final String suffix = ".js";
		final String path = jsRootPath + moduleId + suffix;
		final String templateName = "js.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		List<ColumnClass> columnClassList = new ArrayList<>();
		columnClassList = getColumn(resultSet);
		dataMap.put("model_column",columnClassList);
		generateFileByTemplate(templateName,mapperFile,dataMap);
	}
	private void generateDaoFile(ResultSet resultSet) throws Exception{
		String packagePath = javaRootPath+"dao/";
		createPackage(packagePath);
		final String suffix = "DAO.java";
		final String path = packagePath + moduleId + suffix;
		final String templateName = "DAO.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		generateFileByTemplate(templateName,mapperFile,dataMap);

	}

	private void generateMapperFile(ResultSet resultSet) throws Exception{
		createPackage(mapperRootPath);
		final String suffix = "Mapper.xml";
		final String path = mapperRootPath + moduleId + suffix;
		final String templateName = "Mapper.ftl";
		File mapperFile = new File(path);
		Map<String,Object> dataMap = new HashMap<>();
		List<ColumnClass> columnClassList = new ArrayList<>();
		columnClassList = getColumn(resultSet);
		dataMap.put("model_column",columnClassList);
		dataMap.put("model_id",columnClassList);
		generateFileByTemplate(templateName,mapperFile,dataMap);

	}

	private void generateFileByTemplate(final String templateName,File file,Map<String,Object> dataMap) throws Exception{
		Template template = FreeMarkerTemplateUtils.getTemplate(templateName);
		FileOutputStream fos = new FileOutputStream(file);
		dataMap.put("table_name_small",tableName);
		dataMap.put("table_name",changeTableName);
		dataMap.put("author",AUTHOR);
		dataMap.put("date",CURRENT_DATE);
		dataMap.put("package_name",packageName);
		dataMap.put("table_annotation",tableAnnotation);
		dataMap.put("subMenu",subDirName);
		dataMap.put("moduleId",moduleId);
		dataMap.put("moduleName",moduleName);
		dataMap.put("Dictionaries",Dictionaries);
		dataMap.put("pkMap",pkMap);
		Writer out = new BufferedWriter(new OutputStreamWriter(fos, "utf-8"),10240);
		template.process(dataMap,out);
	}

	public String replaceUnderLineAndUpperCase(String str){
		StringBuffer sb = new StringBuffer();
		sb.append(str);
		int count = sb.indexOf("_");
		while(count!=0){
			int num = sb.indexOf("_",count);
			count = num + 1;
			if(num != -1){
				char ss = sb.charAt(count);
				char ia = (char) (ss - 32);
				sb.replace(count , count + 1,ia + "");
			}
		}
		String result = sb.toString().replaceAll("_","");
		return StringUtils.capitalize(result);
	}



	/**
	 * 
	 * @param sqlType
	 * @return SQL类型得到java类型
	 */
	private static String getJavaTypeFromSQLType(String sqlType){
		String javaType = null;
		int index = sqlType.indexOf("(");
		if(index != -1)
			sqlType = sqlType.substring(0, index);

		if(sqlType.equalsIgnoreCase("VARCHAR2")||sqlType.equalsIgnoreCase("CHAR"))
			javaType = "String";
		else if(sqlType.equalsIgnoreCase("NUMERIC")||sqlType.equalsIgnoreCase("DECIMAL"))
			javaType = "BigDecimal";
		else if(sqlType.equalsIgnoreCase("BIT"))
			javaType = "boolean";
		else if(sqlType.equalsIgnoreCase("TINYINT"))
			javaType = "byte";
		else if(sqlType.equalsIgnoreCase("SAMLLINT"))
			javaType = "short";
		else if(sqlType.equalsIgnoreCase("NUMBER")||sqlType.equalsIgnoreCase("int")||sqlType.equalsIgnoreCase("mediumint"))
			javaType = "int";
		else if(sqlType.equalsIgnoreCase("BIGINT"))
			javaType = "long";
		else if(sqlType.equalsIgnoreCase("REAL"))
			javaType = "float";
		else if(sqlType.equalsIgnoreCase("FLOAT")||sqlType.equalsIgnoreCase("double"))
			javaType = "double";
		else if(sqlType.equalsIgnoreCase("binary")||sqlType.equalsIgnoreCase("varbinary")||sqlType.equalsIgnoreCase("longvarbinary"))
			javaType = "byte[]";
		else if(sqlType.equalsIgnoreCase("date"))
			javaType = "Date";
		else if(sqlType.equalsIgnoreCase("time"))
			javaType = "Time";
		else if(sqlType.equalsIgnoreCase("datetime")||sqlType.equalsIgnoreCase("timestamp"))
			javaType = "Timestamp";
		return javaType;
	}



	/***
	 * 下划线命名转为驼峰命名
	 * 
	 * @param para
	 *        下划线命名的字符串
	 */

	public static String UnderlineToHump(String para){
		StringBuilder result=new StringBuilder();
		String a[]=para.split("_");
		for(String s:a){
			if(result.length()==0){
				result.append(s.toLowerCase());
			}else{
				result.append(s.substring(0, 1).toUpperCase());
				result.append(s.substring(1).toLowerCase());
			}
		}
		return result.toString();
	}

	
	private static List<ColumnClass> getColumn(ResultSet resultSet) throws Exception {
		ColumnClass columnClass = null;
		List<ColumnClass> columnClassList = new ArrayList<>();
		while(resultSet.next()){
			//id字段略过
			if(resultSet.getString("COLUMN_NAME").equals("id")) continue;
			columnClass = new ColumnClass();
			//获取字段名称
			columnClass.setColumnName(resultSet.getString("COLUMN_NAME"));
			//获取字段类型
			columnClass.setColumnType(getJavaTypeFromSQLType(resultSet.getString("TYPE_NAME")));
			//转换字段名称，如 sys_name 变成 SysName
			columnClass.setChangeColumnName(UnderlineToHump(resultSet.getString("COLUMN_NAME")));
			//字段在数据库的注释
			columnClass.setColumnComment(resultSet.getString("REMARKS"));
			columnClassList.add(columnClass);
		}
		return columnClassList;
	}
	
	private static String getPrimaryKeys(ResultSet resultSet) throws Exception {
		StringBuffer pk = new StringBuffer();
		while(resultSet.next()){
		     System.out.print("目录名："+resultSet.getString(1));
		     System.out.print(" 模式名："+resultSet.getString(2));
		     System.out.print(" 表名："+resultSet.getString(3));
		     System.out.print(" 列名顺序号："+resultSet.getString(4));
		     System.out.print(" 列名顺序号："+resultSet.getString(5));
		     System.out.println(" 主键名："+resultSet.getString(6));
		     pk.append(resultSet.getString(4)+",");
		}
		return pk.toString().substring(0, pk.toString().length()-1);
	}
	
}