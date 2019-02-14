<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<!-- ${moduleId}:${moduleName} -->
<mapper namespace="${package_name}.dao.${moduleId}DAO">

    <resultMap id="BaseResultMap" type="${package_name}.entity.${table_name}Entity">
	    <#list model_column as field>
			<result property="${field.changeColumnName}" column="${field.columnName}"/>
		</#list>	
			<result property="timeFrom" column="TIMEFROM"/>
			<result property="timeTo" column="TIMETO"/>
			<result property="line" column="LINE" />
			<result property="state" column="STATE" />
			<result property="error" column="ERROR" />
    </resultMap>

	<!-- 查询 -->
    <select id="findList" resultMap="BaseResultMap">
        SELECT 
        <#list model_column as field>
        	<#if field.columnType?index_of("Date")!=-1>
				to_char(T01.${field.columnName},'yyyy/MM/dd hh24:mi:ss') ${field.columnName}<#if field_has_next>,</#if> 
        	<#else>
				T01.${field.columnName}<#if field_has_next>,</#if> 
        	</#if>
		</#list>
        FROM ${table_name_small} T01
        WHERE 1 = 1
        <#list model_column as field>
        <if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
			AND T01.${field.columnName} = ${"#"}{${field.changeColumnName}}
		</if>
		</#list>
    </select>
    
    <!-- 新增 -->
    <insert id="insert" parameterType="${package_name}.entity.${table_name}Entity">
		INSERT INTO ${table_name_small} 
		<trim prefix="(" suffix=")" suffixOverrides="," >
			<#list model_column as field>
			 <if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
				${field.columnName},
			 </if>
			</#list>
		</trim>
	    VALUES 
	    <trim prefix="(" suffix=")" suffixOverrides="," >
	<#list model_column as field>
    	<if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
	    	<#if field.columnType?index_of("Date")!=-1>
	    		sysdate,
			<#else>
				${"#"}{${field.changeColumnName}},
	    	</#if>
		</if>
	</#list>
	    </trim>
    </insert>
    
    
    
     <!-- 更新  -->
    <update id="update" parameterType="${package_name}.entity.${table_name}Entity">
		UPDATE
			${table_name_small} 
			<set>
				<#list model_column as field>
				
		    	<if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
			    	<#if field.columnName?index_of("ADD_TIME")!=-1>
					<#elseif field.columnName?index_of("ADD_USER")!=-1>
					<#else>
						<#if field.columnType?index_of("Date")!=-1 >
							${field.columnName} = sysdate,
						<#else>
							<#if pkMap?keys?seq_contains("${field.columnName}")>
							<#else>
								${field.columnName} = ${"#"}{${field.changeColumnName}},
							</#if>
							
						</#if>
	        		</#if>
				</if>
				</#list>
			</set>  
	   WHERE 1 = 1
    <#if pkMap?exists>
        <#list pkMap?keys as key> 
        	AND ${key} = ${"#"}{${pkMap[key]!''}}
        </#list>
    </#if>
	</update> 
	
	 <!-- 更新
	<update id="update" parameterType="${package_name}.entity.${table_name}Entity">
	 	UPDATE ${table_name_small}
		   	<set>
			<#list model_column as field>
				<#if field.columnName?index_of("ADD_TIME")!=-1>
				<#elseif field.columnName?index_of("ADD_USER")!=-1>
				<#else>
					<#if field.columnType?index_of("Date")!=-1 >
						${field.columnName} = sysdate,
					<#else>
						<#if pkMap?keys?seq_contains("${field.columnName}")>
						<#else>
							${field.columnName} = ${"#"}{${field.changeColumnName}},
						</#if>
						
					</#if>
        		</#if>
			</#list>
			</set>
		WHERE 1=1
			<#if pkMap?exists>
	        <#list pkMap?keys as key> 
	        	AND ${key} = ${"#"}{${pkMap[key]!''}}
	        </#list>
	   		</#if>
	</update>
  	-->
  	
	<!-- 删除 -->
	<delete id="delete" parameterType="${package_name}.entity.${table_name}Entity">
	    DELETE FROM ${table_name_small}
	    WHERE 1=1
	<#if pkMap?exists>
        <#list pkMap?keys as key> 
        	AND ${key} = ${"#"}{${pkMap[key]!''}}
        </#list>
    </#if>
	</delete>
	
	
	
	<!-- 查询记录数 -->
	<select id="findTotalQty" resultType="java.lang.Integer">
		select count(*) FROM ${table_name_small}
		WHERE 1=1
		<#list model_column as field>
        <if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
			AND ${field.columnName} = ${"#"}{${field.changeColumnName}}
		</if>
		</#list>
	</select>
	
	
	<select id="seacher" resultMap="BaseResultMap">
		SELECT 
		 <#list model_column as field>
        	<#if field.columnType?index_of("Date")!=-1>
				to_char(T01.${field.columnName},'yyyy/MM/dd hh24:mi:ss') ${field.columnName}<#if field_has_next>,</#if> 
        	<#else>
				T01.${field.columnName}<#if field_has_next>,</#if> 
        	</#if>
		</#list>
		FROM ${table_name_small} T01
		WHERE 1=1
		<#list model_column as field>
        <if test="${field.changeColumnName} !=null and ${field.changeColumnName} != ''">
			AND T01.${field.columnName} = ${"#"}{${field.changeColumnName}}
		</if>
		</#list>
		<if test="sort !=null and sort !='' ">
			<if test="order == 'asc'">
				ORDER BY ${"$"}{sort} ASC
			</if>
			<if test="order =='desc'">
				ORDER BY ${"$"}{sort} DESC
			</if>
		</if>
	</select>
	
	
	
	<!-- 清除表数据 -->
	<delete id="deletes">
		DELETE ${table_name_small}_INTERIM where trim(ADD_USER)=${"#"}{userName}
	</delete>


	<!-- 批量插入临时表 -->
	<insert id="insertsTemp" parameterType="java.util.List">
		INSERT INTO ${table_name_small}_INTERIM(
		<#list model_column as field>
			${field.columnName},
		</#list>
		LINE,
		STATE,
		ERROR
		)
		<foreach collection="list" item="idItem" separator="union all">
			select
			<#list model_column as field>
				<#if field.columnType?index_of("Date")!=-1>
					sysdate,
        		<#else>
					${"#"}{idItem.${field.changeColumnName}},
        		</#if>
			</#list>
			${"#"}{idItem.line},
			${"#"}{idItem.state},
			${"#"}{idItem.error}
			from
			dual
		</foreach>
	</insert>

	<insert id="inserts">
		INSERT INTO ${table_name_small}
		<trim prefix="(" suffix=")" suffixOverrides="," >
			<#list model_column as field>
				${field.columnName},
			</#list>
		</trim>
		SELECT 
		<#list model_column as field>
			${field.columnName}<#if field_has_next>,</#if> 
		</#list>
		FROM ${table_name_small}_INTERIM
		Where trim(ADD_USER) = ${"#"}{userName}
	</insert>
	
	
	<!--<insert id="saveOrUpdate" parameterType="${package_name}.entity.${table_name}Entity">
		<selectKey keyProperty="count" resultType="int" order="BEFORE">
	    	SELECT COUNT(*) FROM ${table_name_small} 
	    	WHERE 1 = 1
	    	<#if pkMap?exists>
                <#list pkMap?keys as key> 
                	AND ${key} = ${"#"}{${pkMap[key]!''}}
                </#list>
            </#if>
	  	</selectKey>
	  	<if test="count != 0">
		    UPDATE ${table_name_small}
		   	<set>
			<#list model_column as field>
				<#if field.columnName?index_of("ADD_TIME")!=-1>
				<#elseif field.columnName?index_of("ADD_USER")!=-1>
				<#else>
					<#if field.columnType?index_of("Date")!=-1 >
						${field.columnName} = sysdate,
					<#else>
						<#if pkMap?keys?seq_contains("${field.columnName}")>
						<#else>
							${field.columnName} = ${"#"}{${field.changeColumnName}},
						</#if>
						
					</#if>
        		</#if>
			</#list>
			</set> 
	  	</if>
	 	 <if test="count==0">
	    	INSERT INTO ${table_name_small}
	    	<trim prefix="(" suffix=")" suffixOverrides="," >
				<#list model_column as field>
					${field.columnName},
				</#list>
			</trim>
			VALUES
	    	<trim prefix="(" suffix=")" suffixOverrides="," >
		    	<#list model_column as field>
		    	<#if field.columnType?index_of("Date")!=-1 >
					sysdate,
				<#else>
					${"#"}{${field.changeColumnName}},
				</#if>
				</#list>
	    </trim>
	  	</if>
	</insert>-->
	
	<!-- 分页与条件查询临时表 -->
	<select id="findTempLists" resultMap="BaseResultMap">
		select
			LINE,
			STATE,
			ERROR
		from
			${table_name_small}_INTERIM
		where
		 	STATE = '2'
		 	and trim(ADD_USER)=${"#"}{addUser}
	</select>
	
	
	<insert id="saveOrUpdate" parameterType="${package_name}.entity.${table_name}Entity">
		MERGE INTO ${table_name_small} A
		USING (SELECT * FROM ${table_name_small}_INTERIM  WHERE
		TRIM(ADD_USER)=${"#"}{userName}) B
		ON (	1=1
			<#if pkMap?exists>
		        <#list pkMap?keys as key> 
		        	AND A.${key} = B.${key}
		        </#list>
		    </#if>
		)
		WHEN MATCHED THEN
		UPDATE
		<set>
			<#list model_column as field>
				<#if field.columnName?index_of("ADD_TIME")!=-1>
				<#elseif field.columnName?index_of("ADD_USER")!=-1>
				<#else>
					<#if field.columnType?index_of("Date")!=-1 >
						${field.columnName} = sysdate,
					<#else>
						<#if pkMap?keys?seq_contains("${field.columnName}")>
						<#else>
							${field.columnName} = B.${field.columnName},
						</#if>
						
					</#if>
        		</#if>
			</#list>
		</set> 
		WHEN NOT MATCHED THEN
		INSERT
		<trim prefix="(" suffix=")" suffixOverrides="," >
				<#list model_column as field>
					${field.columnName},
				</#list>
			</trim>
			VALUES
	    	<trim prefix="(" suffix=")" suffixOverrides="," >
		    	<#list model_column as field>
		    	<#if field.columnType?index_of("Date")!=-1 >
					sysdate,
				<#else>
					B.${field.columnName},
				</#if>
				</#list>
	   	</trim>
	</insert>
	
	<!-- 校验是否有重复导入数据 -->
	<select id="checkPrimaryKey" resultMap="BaseResultMap">
		select 
	    <#list model_column as field>
        	<#if field.columnType?index_of("Date")!=-1>
				to_char(T01.${field.columnName},'yyyy/MM/dd hh24:mi:ss') ${field.columnName},
        	<#else>
				T01.${field.columnName},
        	</#if>
		</#list>
		  T01.LINE,
	      T01.STATE,
	      T01.ERROR
	    from 
	      ${table_name_small}_INTERIM T01
	    where exists (
	      select 
	      <#if pkMap?exists>
	        <#list pkMap?keys as key> 
	        	T02.${key}<#if key_has_next>,</#if> 
	        </#list>
	      </#if>
	        from ${table_name_small}_INTERIM T02 
	      where T02.Add_User=${"#"}{userName}
	      <#if pkMap?exists>
	        <#list pkMap?keys as key> 
	        	and T01.${key}=T02.${key}
	        </#list>
	      </#if>
	      group by 
	      <#if pkMap?exists>
	        <#list pkMap?keys as key> 
	        	T02.${key}<#if key_has_next>,</#if> 
	        </#list>
	      </#if>
	      	having count(*) > 1)
	</select>
	
	<!-- 更新错误信息 -->
	<update id="updateTemp">
		update ${table_name_small}_INTERIM
			set 
				STATE = ${"#"}{state},
				ERROR = ${"#"}{error}
		where 
			LINE = ${"#"}{line}
			AND ADD_USER = ${"#"}{addUser}
		<#if pkMap?exists>
        <#list pkMap?keys as key> 
        	AND ${key} = ${"#"}{${pkMap[key]!''}}
        </#list>
   		</#if>
	</update>
	
</mapper>