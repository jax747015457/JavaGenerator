package com.evada.inno.pm.code.generate.model;

/**
 * 数据库字段封装类
 * Created by Wenn
 */
public class ColumnClass {
	/**  XXXX$Y(conditionStatus)/Y(editStatus)  **/
	
    /** 数据库字段名称 **/
    private String columnName;
    /** 数据库字段类型 **/
    private String columnType;
    /** 数据库字段首字母小写且去掉下划线字符串 **/
    private String changeColumnName;
    /** 数据库字段注释 **/
    private String columnComment;
    /**是否作为检索条件Y/N**/
    private String conditionStatus;
    /**是否作为比编辑条件Y/N**/
    private String editStatus;

    
    public String getConditionStatus() {
		return conditionStatus;
	}

	public void setConditionStatus(String conditionStatus) {
		this.conditionStatus = conditionStatus;
	}

	public String getEditStatus() {
		return editStatus;
	}

	public void setEditStatus(String editStatus) {
		this.editStatus = editStatus;
	}

	public String getColumnComment() {
        return columnComment;
    }

    public void setColumnComment(String columnComment) {
        this.columnComment = columnComment;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnType() {
        return columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    public String getChangeColumnName() {
        return changeColumnName;
    }

    public void setChangeColumnName(String changeColumnName) {
        this.changeColumnName = changeColumnName;
    }
}